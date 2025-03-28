from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime

SalesRouter = APIRouter(tags=["Sales"])

# Sales Response Model
class SalesResponse(BaseModel):
    name: str
    quantity: int
    unit_price: float
    items_sold: int
    remitted: float
    image_url: str  # Include image URL

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
        today = datetime.now().date()  # Get today's date

        # Fetch and aggregate sales per product for today, including product image
        cursor.execute("""
            SELECT 
                ip.ProductName, ip.Quantity, ip.UnitPrice, ip.Image,
                COALESCE(SUM(s.quantity_sold), 0) AS total_items_sold, 
                COALESCE(SUM(s.remitted), 0) AS total_remitted
            FROM inventoryproduct ip
            LEFT JOIN sales s ON ip.id = s.product_id AND DATE(s.created_at) = %s  
            GROUP BY ip.id, ip.ProductName, ip.Quantity, ip.UnitPrice, ip.Image
            ORDER BY ip.id ASC
        """, (today,))

        sales_data = cursor.fetchall()

        if not sales_data:
            return []  

        return [
            {
                "name": row[0],
                "quantity": row[1],
                "unit_price": float(row[2]),
                "items_sold": row[4],
                "remitted": float(row[5]),
                "image_url": row[3] if row[3] else ""  
            }
            for row in sales_data
        ]
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@SalesRouter.post("/sales/update")
async def update_sales(sales_update: SalesUpdateRequest, db=Depends(get_db)):
    try:
        cursor, conn = db

        cursor.execute("SELECT Quantity FROM inventoryproduct WHERE id = %s", (sales_update.product_id,))
        product = cursor.fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        available_stock = product[0]

        if available_stock < sales_update.quantity_sold:
            raise HTTPException(status_code=400, detail="Not enough stock available")

        cursor.execute("""
            INSERT INTO sales (product_id, quantity_sold, remitted, created_at)
            VALUES (%s, %s, %s, NOW())
            ON DUPLICATE KEY UPDATE 
                quantity_sold = quantity_sold + VALUES(quantity_sold), 
                remitted = remitted + VALUES(remitted)
        """, (sales_update.product_id, sales_update.quantity_sold, sales_update.remitted))

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

@SalesRouter.get("/total-sales-revenue", response_model=dict)
async def get_total_sales_revenue(db=Depends(get_db)):
    try:
        cursor = db[0]
        today = datetime.now().date()  # Get today's date

        # SQL query to calculate total sales revenue for today
        cursor.execute("""
            SELECT COALESCE(SUM(s.remitted), 0) AS total_revenue
            FROM sales s
            WHERE DATE(s.created_at) = %s
        """, (today,))

        total_revenue = cursor.fetchone()[0]

        return {"total_sales_revenue": total_revenue}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
