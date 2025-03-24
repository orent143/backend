from fastapi import APIRouter, Request, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db

CreateOrderRouter = APIRouter(tags=["CreateOrders"])

class CreateOrderRequest(BaseModel):
    customer_name: str
    cash_on_hand: float               # Added cash on hand
    items: List[dict]  
    total_amount: float

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
@CreateOrderRouter.post("/create_order")
async def create_order(order_data: CreateOrderRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        if order_data.total_amount <= 0:
            raise HTTPException(status_code=400, detail="Total amount must be greater than zero")

        # Validate cash on hand
        if order_data.cash_on_hand < order_data.total_amount:
            raise HTTPException(status_code=400, detail="Insufficient cash on hand")

        # Calculate the change
        change = order_data.cash_on_hand - order_data.total_amount

        # Validate stock for each item
        for item in order_data.items:
            product_id = item["id"]

            cursor.execute("""
                SELECT Quantity, UnitPrice, ProcessType 
                FROM inventoryproduct 
                WHERE id = %s
            """, (product_id,))
            
            product = cursor.fetchone()
            
            if not product:
                raise HTTPException(status_code=404, detail=f"Product ID {product_id} not found")
            
            # Only check quantity for Ready-Made products
            if product[2] != "To Be Made" and item["quantity"] > product[0]:
                raise HTTPException(status_code=400, detail=f"Insufficient stock for Product ID {product_id}")

        # Create the order
        cursor.execute(
            """
            INSERT INTO orders (CustomerName, OrderDate, CashOnHand, TotalAmount, OrderStatus) 
            VALUES (%s, NOW(), %s, %s, 'Pending')
            """,
            (order_data.customer_name, order_data.cash_on_hand, order_data.total_amount)
        )
        conn.commit()

        cursor.execute("SELECT LAST_INSERT_ID()")
        order_id = cursor.fetchone()[0]

        # Process each ordered item
        for item in order_data.items:
            product_id = item.get("product_id", item.get("id"))
            quantity_sold = item["quantity"]

            cursor.execute(
                "INSERT INTO order_items (OrderID, ProductID, Quantity) VALUES (%s, %s, %s)",
                (order_id, product_id, quantity_sold)
            )

            cursor.execute("SELECT ProcessType FROM inventoryproduct WHERE id = %s", (product_id,))
            process_type = cursor.fetchone()[0]
            
            if process_type != "To Be Made":
                cursor.execute(
                    "UPDATE inventoryproduct SET Quantity = Quantity - %s WHERE id = %s",
                    (quantity_sold, product_id)
                )

            cursor.execute("SELECT UnitPrice FROM inventoryproduct WHERE id = %s", (product_id,))
            unit_price = cursor.fetchone()[0]
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
        
        return {
            "message": "Order created successfully and sales updated",
            "order_id": order_id,
            "cash_on_hand": order_data.cash_on_hand,
            "change": change
        }
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
