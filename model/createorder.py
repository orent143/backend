from fastapi import APIRouter, Request, Depends, HTTPException
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db

CreateOrderRouter = APIRouter(tags=["CreateOrders"])

# Improved Pydantic model with default values
class CreateOrderRequest(BaseModel):
    customer_name: str
    items: List[dict]
    total_amount: float
    payment_method: str  # Cash or Tally

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

@CreateOrderRouter.post("/create_order")
async def create_order(order_data: CreateOrderRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        # Validate total amount
        if order_data.total_amount <= 0:
            raise HTTPException(status_code=400, detail="Total amount must be greater than zero")

        total_items = 0

        for item in order_data.items:
            product_id = item["id"]
            quantity_requested = item["quantity"]

            # Fetch product details
            cursor.execute(
                "SELECT Quantity, UnitPrice, ProcessType, ProductName FROM inventoryproduct WHERE id = %s",
                (product_id,)
            )
            product = cursor.fetchone()

            if not product:
                raise HTTPException(status_code=404, detail=f"Product ID {product_id} not found")

            current_stock, unit_price, process_type, product_name = product

            if process_type != "To Be Made" and quantity_requested > current_stock:
                raise HTTPException(
                    status_code=400,
                    detail=f"Insufficient stock for {product_name} (ID {product_id})"
                )

            total_items += quantity_requested

        # ✅ Insert into `order_history`
        cursor.execute(
            """
            INSERT INTO order_history (customer_name, created_at, total_amount, payment_method, total_items)
            VALUES (%s, NOW(), %s, %s, %s)
            """,
            (
                order_data.customer_name,
                order_data.total_amount,
                order_data.payment_method,
                total_items
            )
        )
        conn.commit()

        # ✅ Retrieve the new `history_id`
        cursor.execute("SELECT LAST_INSERT_ID(), created_at FROM order_history ORDER BY history_id DESC LIMIT 1")
        result = cursor.fetchone()
        history_id, created_at = result[0], result[1]

        # ✅ Insert into `order_history_detail` and deduct stock
        for item in order_data.items:
            product_id = item["id"]
            quantity_sold = item["quantity"]

            # Fetch product details again
            cursor.execute(
                "SELECT Quantity, UnitPrice, ProcessType, ProductName FROM inventoryproduct WHERE id = %s",
                (product_id,)
            )
            product = cursor.fetchone()

            if not product:
                raise HTTPException(status_code=404, detail=f"Product ID {product_id} not found")

            current_stock, unit_price, process_type, product_name = product

            # Insert order details
            cursor.execute(
                """
                INSERT INTO order_history_detail (order_id, product_id, product_name, quantity, product_price)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (history_id, product_id, product_name, quantity_sold, unit_price)
            )

            # ✅ Deduct stock (FIFO for "Ready-Made" items)
            if process_type != "To Be Made":
                remaining_quantity = quantity_sold

                # Deduct stock in FIFO order
                while remaining_quantity > 0:
                    cursor.execute(
                        """
                        SELECT id, quantity 
                        FROM stock_details 
                        WHERE ProductID = %s AND quantity > 0 
                        ORDER BY created_at ASC
                        LIMIT 1
                        """,
                        (product_id,)
                    )
                    batch = cursor.fetchone()

                    if not batch:
                        raise HTTPException(status_code=400, detail=f"Insufficient stock for {product_name}")

                    batch_id, batch_quantity = batch

                    if remaining_quantity >= batch_quantity:
                        # Deduct the entire batch
                        cursor.execute(
                            "UPDATE stock_details SET quantity = 0 WHERE id = %s",
                            (batch_id,)
                        )
                        remaining_quantity -= batch_quantity
                    else:
                        # Deduct only the requested quantity
                        cursor.execute(
                            "UPDATE stock_details SET quantity = quantity - %s WHERE id = %s",
                            (remaining_quantity, batch_id)
                        )
                        remaining_quantity = 0

                    # ✅ Log the deduction in `inventory_transactions`
                    cursor.execute(
                        """
                        INSERT INTO inventory_transactions 
                        (ProductID, product_name, transaction_type, quantity, created_at)
                        VALUES (%s, %s, %s, %s, NOW())
                        """,
                        (product_id, product_name, "Deduct", quantity_sold)  # Added `ProductID`
                    )

                # ✅ Update `inventoryproduct` table
                cursor.execute(
                    "UPDATE inventoryproduct SET Quantity = Quantity - %s WHERE id = %s",
                    (quantity_sold, product_id)
                )

            # ✅ Update sales table
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
            "message": "Order created successfully and moved to history",
            "history_id": history_id,
            "created_at": created_at,
            "payment_method": order_data.payment_method,
            "total_items": total_items
        }

    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create order: {str(e)}")