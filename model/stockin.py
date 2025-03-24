from fastapi import Depends, HTTPException, APIRouter, Form, Request
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime
import logging

StockRouter = APIRouter(tags=["Stock In"])
class StockItem(BaseModel):
    stock_location: str
    batch_number: str
    quantity: int
    expiration_date: str
    cost_price: float
    SupplierID: Optional[int] = None

class StockInRequest(BaseModel):
    ProductID: str
    Stocks: List[StockItem]

def log_activity(db, icon: str, title: str, status: str):
    try:
        db[0].execute(
            "INSERT INTO activity_logs (icon, title, time, status) VALUES (%s, %s, NOW(), %s)",
            (icon, title, status),
        )
        db[1].commit()
    except Exception as e:
        print(f"Failed to log activity: {e}")
def log_inventory_transaction(db, product_name: str, transaction_type: str, 
                            quantity: int, cost_price: float):
    try:
        db[0].execute("""
            INSERT INTO inventory_transactions 
            (product_name, transaction_type, quantity, cost_price)
            VALUES (%s, %s, %s, %s)
        """, (product_name, transaction_type, quantity, cost_price))
        db[1].commit()
    except Exception as e:
        print(f"Failed to log inventory transaction: {e}")
        raise
logger = logging.getLogger(__name__)

@StockRouter.post("/stockin/")
async def stock_in(request: StockInRequest, db=Depends(get_db)):
    try:
        db[0].execute("SELECT ProductName FROM inventoryproduct WHERE id = %s", (request.ProductID,))
        product = db[0].fetchone()
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        total_quantity = 0
        for stock in request.Stocks:
            total_quantity += stock.quantity

            exp_date = None if not stock.expiration_date or stock.expiration_date == "0000-00-00" else datetime.strptime(stock.expiration_date, "%Y-%m-%d").date()

            db[0].execute(
                "INSERT INTO stock_details (ProductID, stock_location, batch_number, quantity, expiration_date, cost_price, SupplierID) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (request.ProductID, stock.stock_location, stock.batch_number, stock.quantity, exp_date, stock.cost_price, stock.SupplierID)
            )

            # Log each stock addition as a transaction
            log_inventory_transaction(
                db=db,
                product_name=product[0],
                transaction_type="Add",
                quantity=stock.quantity,
                cost_price=stock.cost_price
            )

        db[0].execute("UPDATE inventoryproduct SET Quantity = Quantity + %s WHERE id = %s", (total_quantity, request.ProductID))
        db[1].commit()

        log_activity(db, "pi pi-box", f"Stock added for {product[0]}", "Success")

        return {"message": "Stock added successfully", "ProductID": request.ProductID, "TotalQuantity": total_quantity}

    except Exception as e:
        logger.error(f"Error in stock_in: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    
@StockRouter.get("/stockin/{product_id}", response_model=dict)
async def get_product_details(product_id: str, db=Depends(get_db)):
    db[0].execute("""
        SELECT 
            ip.id, 
            ip.ProductName, 
            ip.Quantity, 
            ip.ProcessType, 
            ip.Image, 
            s.SupplierName,
            sd.cost_price
        FROM inventoryproduct ip
        LEFT JOIN stock_details sd ON ip.id = sd.ProductID
        LEFT JOIN suppliers s ON sd.SupplierID = s.id
        WHERE ip.id = %s
        ORDER BY sd.created_at DESC LIMIT 1
    """, (product_id,))
    
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    base_url = "http://127.0.0.1:8000/uploads/products/"

    return {
        "ProductID": product[0],
        "ProductName": product[1],
        "Quantity": product[2],
        "ProcessType": product[3],
        "Image": f"{base_url}{product[4]}" if product[4] else None,
        "CurrentSupplier": product[5],
        "CostPrice": float(product[6]) if product[6] else None  # Changed from UnitPrice to CostPrice
    }
@StockRouter.get("/stockdetails/{product_id}", response_model=dict)
async def get_stock_details(product_id: str, db=Depends(get_db)):
    db[0].execute("""
        SELECT 
            sd.id,
            sd.stock_location,
            sd.batch_number,
            sd.quantity,
            sd.expiration_date,
            sd.created_at,
            sd.cost_price,  -- Include the cost price
            s.SupplierName
        FROM stock_details sd
        LEFT JOIN suppliers s ON sd.SupplierID = s.id
        WHERE sd.ProductID = %s
        ORDER BY sd.created_at DESC
    """, (product_id,))

    stocks = db[0].fetchall()

    if not stocks:
        raise HTTPException(status_code=404, detail="No stock details found")

    stock_list = [
        {
            "id": stock[0],
            "stock_location": stock[1],
            "batch_number": stock[2],
            "quantity": stock[3],
            "expiration_date": stock[4].strftime('%Y-%m-%d') if stock[4] else None,
            "created_at": stock[5],
            "CostPrice": float(stock[6]) if stock[6] else 0.0,  # Convert to float
            "SupplierName": stock[7] or "Unknown"
        }
        for stock in stocks
    ]

    return {"StockDetails": stock_list}


@StockRouter.get("/inventory-transactions", response_model=list)
async def get_inventory_transactions(db=Depends(get_db)):
    """Fetch all inventory transactions."""
    try:
        db[0].execute("""
            SELECT id, product_name, transaction_type, quantity, cost_price, created_at
            FROM inventory_transactions
            ORDER BY created_at DESC
        """)
        
        transactions = db[0].fetchall()
        
        return [
            {
                "id": t[0],
                "product_name": t[1],
                "transaction_type": t[2],
                "quantity": t[3],
                "cost_price": float(t[4]),
                "created_at": t[5].strftime("%Y-%m-%d %H:%M:%S")
            }
            for t in transactions
        ]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching transactions: {str(e)}")