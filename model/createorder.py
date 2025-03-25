from fastapi import APIRouter, Request, Depends, HTTPException
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db

CreateOrderRouter = APIRouter(tags=["CreateOrders"])

# Improved Pydantic model with default values
class CreateOrderRequest(BaseModel):
    customer_name: str
    cash_on_hand: Optional[float] = 0.00  # Default to 0.00
    items: List[dict]
    total_amount: float
    payment_method: str  # Cash or Tally
    employee_id: Optional[int] = None  # Only for Tally payments



@CreateOrderRouter.get("/menu_items/all")
async def get_all_menu_items(request: Request, db=Depends(get_db)):
    """Fetch all menu items with their details."""
    try:
        base_url = str(request.base_url)
        
        query = """
            SELECT 
                ip.id,
                ip.ProductName,
                ip.UnitPrice,
                ip.Quantity,
                ip.ProcessType,
                ip.Image,       
                c.CategoryName
            FROM inventoryproduct ip
            LEFT JOIN categories c ON ip.`CategoryID (FK)` = c.id
            ORDER BY c.CategoryName, ip.ProductName
        """
        
        db[0].execute(query)
        menu_items = db[0].fetchall()
        
        # Apply infinite stock for "To Be Made" items
        return [
            {
                "id": item[0],
                "name": item[1],
                "price": float(item[2]),
                "stock": '∞' if item[4] == "To Be Made" else item[3],
                "process_type": item[4],
                "image": f"{base_url}uploads/products/{item[5]}" if item[5] else None,
                "category": item[6],
                "status": "Available" if item[4] == "To Be Made" else (
                    "Out of Stock" if item[3] == 0 else "In Stock"
                )
            }
            for item in menu_items
        ]

    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Error fetching menu items: {str(e)}"
        )

# Update the create_order endpoint

# 🚀 Improved Create Order Endpoint
@CreateOrderRouter.post("/create_order")
async def create_order(order_data: CreateOrderRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        # Validate total amount
        if order_data.total_amount <= 0:
            raise HTTPException(status_code=400, detail="Total amount must be greater than zero")

        # Handle payment types and cash on hand
        cash_on_hand = order_data.cash_on_hand if order_data.payment_method == "Cash" else 0.00
        change = 0.00

        if order_data.payment_method == "Cash":
            if order_data.cash_on_hand is None or order_data.cash_on_hand < order_data.total_amount:
                raise HTTPException(status_code=400, detail="Insufficient cash on hand")
            
            change = order_data.cash_on_hand - order_data.total_amount

        # Validate stock for each item
        for item in order_data.items:
            product_id = item.get("id")  # Use consistent key reference
            quantity_requested = item["quantity"]

            cursor.execute(
                "SELECT Quantity, UnitPrice, ProcessType FROM inventoryproduct WHERE id = %s",
                (product_id,)
            )
            
            product = cursor.fetchone()
            
            if not product:
                raise HTTPException(status_code=404, detail=f"Product ID {product_id} not found")
            
            current_stock, unit_price, process_type = product

            # Stock validation for "To Be Made" items (infinite stock)
            if process_type != "To Be Made" and quantity_requested > current_stock:
                raise HTTPException(
                    status_code=400,
                    detail=f"Insufficient stock for Product ID {product_id}"
                )

        # ✅ Insert order into orders table
        if order_data.payment_method == "Tally":
            # Insert with employee_id for Tally payments
            cursor.execute(
                """
                INSERT INTO orders (CustomerName, OrderDate, CashOnHand, TotalAmount, OrderStatus, PaymentMethod, EmployeeID) 
                VALUES (%s, NOW(), %s, %s, 'Pending', %s, %s)
                """,
                (
                    order_data.customer_name,
                    cash_on_hand,
                    order_data.total_amount,
                    order_data.payment_method,
                    order_data.employee_id  # Include employee_id only for Tally
                )
            )
        else:
            # Insert without employee_id for Cash payments
            cursor.execute(
                """
                INSERT INTO orders (CustomerName, OrderDate, CashOnHand, TotalAmount, OrderStatus, PaymentMethod) 
                VALUES (%s, NOW(), %s, %s, 'Pending', %s)
                """,
                (
                    order_data.customer_name,
                    cash_on_hand,
                    order_data.total_amount,
                    order_data.payment_method
                )
            )

        conn.commit()

        # Get the new OrderID
        cursor.execute("SELECT LAST_INSERT_ID()")
        order_id = cursor.fetchone()[0]

        # ✅ Process each ordered item
        for item in order_data.items:
            product_id = item["id"]
            quantity_sold = item["quantity"]

            # Insert into order_items table
            cursor.execute(
                "INSERT INTO order_items (OrderID, ProductID, Quantity) VALUES (%s, %s, %s)",
                (order_id, product_id, quantity_sold)
            )

            # Get process type again
            cursor.execute(
                "SELECT ProcessType, UnitPrice FROM inventoryproduct WHERE id = %s",
                (product_id,)
            )
            process_type, unit_price = cursor.fetchone()

            # Decrement stock for non "To Be Made" items
            if process_type != "To Be Made":
                cursor.execute(
                    "UPDATE inventoryproduct SET Quantity = Quantity - %s WHERE id = %s",
                    (quantity_sold, product_id)
                )

            # Update sales table
            remitted_amount = unit_price * quantity_sold

            cursor.execute(
                """
                INSERT INTO sales (product_id, quantity_sold, remitted)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE 
                    quantity_sold = quantity_sold + VALUES(quantity_sold), 
                    remitted = remitted + VALUES(remitted)
                """, (product_id, quantity_sold, remitted_amount)
            )

        conn.commit()

        # ✅ Return the employee_id if it exists (for Tally payments)
        return {
            "message": "Order created successfully and sales updated",
            "order_id": order_id,
            "cash_on_hand": cash_on_hand,
            "change": change,
            "payment_method": order_data.payment_method,
            "employee_id": order_data.employee_id if order_data.payment_method == "Tally" else None
        }

    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create order: {str(e)}")
