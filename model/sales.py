from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db

SalesRouter = APIRouter(tags=["Sales"])

# Sales Response Model
class SalesResponse(BaseModel):
    name: str
    quantity: int
    unit_price: float
    items_sold: int
    remitted: float

# Sales Update Model
class SalesUpdateRequest(BaseModel):
    product_id: int
    quantity_sold: int
    remitted: float

# Fetch sales data
@SalesRouter.get("/sales", response_model=List[SalesResponse])
async def get_sales_data(db=Depends(get_db)):
    try:
        cursor = db[0]
        cursor.execute("""
            SELECT 
                ip.ProductName, ip.Quantity, ip.UnitPrice, 
                COALESCE(s.quantity_sold, 0) AS items_sold, 
                COALESCE(s.remitted, 0) AS remitted
            FROM inventoryproduct ip
            LEFT JOIN sales s ON ip.id = s.product_id
        """)
        sales_data = cursor.fetchall()

        return [
            {
                "name": row[0],
                "quantity": row[1],
                "unit_price": float(row[2]),
                "items_sold": row[3],
                "remitted": float(row[4])
            }
            for row in sales_data
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# Update Sales when an order is created or completed
@SalesRouter.post("/sales/update")
async def update_sales(sales_update: SalesUpdateRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        # Check if product exists
        cursor.execute("SELECT Quantity FROM inventoryproduct WHERE id = %s", (sales_update.product_id,))
        product = cursor.fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        available_stock = product[0]

        # Ensure there is enough stock
        if available_stock < sales_update.quantity_sold:
            raise HTTPException(status_code=400, detail="Not enough stock available")

        # Update Sales Table
        cursor.execute("""
            INSERT INTO sales (product_id, quantity_sold, remitted)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE 
                quantity_sold = quantity_sold + VALUES(quantity_sold), 
                remitted = remitted + VALUES(remitted)
        """, (sales_update.product_id, sales_update.quantity_sold, sales_update.remitted))

        # Deduct from Inventory
        cursor.execute("""
            UPDATE inventoryproduct 
            SET Quantity = Quantity - %s 
            WHERE id = %s
        """, (sales_update.quantity_sold, sales_update.product_id))

        conn.commit()
        return {"message": "Sales updated successfully"}
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
