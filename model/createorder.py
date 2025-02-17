from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db

CreateOrderRouter = APIRouter(tags=["CreateOrders"])

# Order Request Model
class CreateOrderRequest(BaseModel):
    customer_name: str
    table_number: int
    items: List[dict]  # Example: [{ "id": 1, "quantity": 2 }]
    total_amount: float

# Fetch menu items from inventoryproduct
@CreateOrderRouter.get("/menu_items")
async def get_menu_items(db=Depends(get_db)):
    db[0].execute("SELECT id, ProductName, UnitPrice, Quantity FROM inventoryproduct WHERE Quantity > 0")
    products = db[0].fetchall()

    return [
        {"id": product[0], "name": product[1], "price": float(product[2]), "stock": product[3]}
        for product in products
    ]

# Create a new order and update sales
@CreateOrderRouter.post("/create_order")
async def create_order(order_data: CreateOrderRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        if order_data.total_amount <= 0:
            raise HTTPException(status_code=400, detail="Total amount must be greater than zero")

        # Validate stock availability
        for item in order_data.items:
            cursor.execute("SELECT Quantity, UnitPrice FROM inventoryproduct WHERE id = %s", (item["id"],))
            product = cursor.fetchone()
            if not product:
                raise HTTPException(status_code=404, detail=f"Product ID {item['id']} not found")
            if item["quantity"] > product[0]:
                raise HTTPException(status_code=400, detail=f"Insufficient stock for Product ID {item['id']}")

        # Insert order into 'orders' table
        cursor.execute(
            """
            INSERT INTO orders (CustomerName, TableNumber, OrderDate, TotalAmount, OrderStatus) 
            VALUES (%s, %s, NOW(), %s, 'Pending')
            """,
            (order_data.customer_name, order_data.table_number, order_data.total_amount),
        )
        conn.commit()

        # Get the last inserted OrderID
        cursor.execute("SELECT LAST_INSERT_ID()")
        order_id = cursor.fetchone()[0]

        # Insert order items, update stock, and update sales
        for item in order_data.items:
            product_id = item["id"]
            quantity_sold = item["quantity"]

            # Insert into order_items table
            cursor.execute(
                "INSERT INTO order_items (OrderID, ProductID, Quantity) VALUES (%s, %s, %s)",
                (order_id, product_id, quantity_sold)
            )

            # Reduce stock in inventory
            cursor.execute(
                "UPDATE inventoryproduct SET Quantity = Quantity - %s WHERE id = %s",
                (quantity_sold, product_id)
            )

            # Fetch unit price
            cursor.execute("SELECT UnitPrice FROM inventoryproduct WHERE id = %s", (product_id,))
            unit_price = cursor.fetchone()[0]

            # Calculate remitted amount (total earnings from sales)
            remitted_amount = unit_price * quantity_sold

            # Update sales table
            cursor.execute("""
                INSERT INTO sales (product_id, quantity_sold, remitted)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE 
                    quantity_sold = quantity_sold + VALUES(quantity_sold), 
                    remitted = remitted + VALUES(remitted)
            """, (product_id, quantity_sold, remitted_amount))

        conn.commit()

        return {"message": "Order created successfully and sales updated", "order_id": order_id}
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
