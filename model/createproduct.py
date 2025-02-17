from fastapi import Depends, HTTPException, APIRouter, Form
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
import json

CreateProductRouter = APIRouter(tags=["CreateProduct"])

# Pydantic Model for Stock Input
class ProductStock(BaseModel):
    StockID: int
    StockQuantity: int

class ProductCreate(BaseModel):
    ProductName: str
    CategoryID: int
    UnitPrice: float
    Quantity: int
    Stocks: Optional[List[ProductStock]] = []

@CreateProductRouter.post("/products/", response_model=dict)
async def create_product(
    ProductName: str = Form(...),
    CategoryID: int = Form(...),
    Quantity: int = Form(...),
    UnitPrice: float = Form(...),
    Stocks: Optional[str] = Form("[]"),  # JSON string containing stock details
    db=Depends(get_db)
):
    try:
        # Convert JSON string to list
        stock_list = json.loads(Stocks) if Stocks else []

        # Insert product into inventoryproduct
        query_insert_product = """
        INSERT INTO inventoryproduct (ProductName, Quantity, UnitPrice, `CategoryID (FK)`)
        VALUES (%s, %s, %s, %s)
        """
        values = (ProductName, Quantity, UnitPrice, CategoryID)
        db[0].execute(query_insert_product, values)
        db[1].commit()

        # Get the newly inserted Product ID
        db[0].execute("SELECT LAST_INSERT_ID()")
        new_product_id = db[0].fetchone()[0]

        # Update stocks table instead of product_stock
        for stock in stock_list:
            query_update_stock = """
            UPDATE stocks
            SET Quantity = Quantity - %s
            WHERE StockID = %s AND Quantity >= %s
            """
            db[0].execute(query_update_stock, (stock["StockQuantity"], stock["StockID"], stock["StockQuantity"]))

        db[1].commit()

        return {"id": new_product_id, "message": "Product created successfully"}
    
    except Exception as e:
        db[1].rollback()  # Rollback in case of an error
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# Fetch categories and stocks
@CreateProductRouter.get("/products/prepopulate", response_model=dict)
async def prepopulate_product_form(db=Depends(get_db)):
    try:
        categories = fetch_categories(db)
        stocks = fetch_stock(db)
        return {"categories": categories, "stocks": stocks}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching prepopulate data: {str(e)}")

def fetch_categories(db):
    """Fetch all categories from the database"""
    try:
        query = "SELECT id, CategoryName FROM categories"  # Corrected table and column names
        db[0].execute(query)
        categories = [{"id": row[0], "CategoryName": row[1]} for row in db[0].fetchall()]
        return categories
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching categories: {str(e)}")


def fetch_stock(db):
    """Fetch all stock items from the database"""
    try:
        query = "SELECT StockID, StockName, Quantity FROM stocks"
        db[0].execute(query)
        stocks = [{"StockID": row[0], "StockName": row[1], "Quantity": row[2]} for row in db[0].fetchall()]
        return stocks
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching stocks: {str(e)}")
