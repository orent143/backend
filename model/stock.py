from fastapi import Depends, HTTPException, APIRouter, Form
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime

StockRouter = APIRouter(tags=["Stocks"])

# Pydantic Model for Stock Update
class StockUpdate(BaseModel):
    StockName: Optional[str] = None
    Quantity: Optional[int] = None
    CostPrice: Optional[float] = None
    SupplierID: Optional[int] = None

# Function to determine stock status
def determine_stock_status(quantity: int) -> str:
    if quantity == 0:
        return "Out of Stock"
    elif quantity <= 10:
        return "Low Stock"
    else:
        return "In Stock"

# ✅ Get All Stocks
@StockRouter.get("/", response_model=list)
async def read_stocks(db=Depends(get_db)):
    query = "SELECT StockID, StockName, Quantity, CostPrice, SupplierID, Status FROM stocks"
    db[0].execute(query)
    stocks = [{"StockID": stock[0], "StockName": stock[1], "Quantity": stock[2], "CostPrice": stock[3],
               "SupplierID": stock[4], "Status": stock[5]} for stock in db[0].fetchall()]
    return stocks

# ✅ Get Stock by ID
@StockRouter.get("/stocks/{stock_id}", response_model=dict)
async def read_stock(stock_id: int, db=Depends(get_db)):
    query = "SELECT StockID, StockName, Quantity, CostPrice, SupplierID, Status FROM stocks WHERE StockID = %s"
    db[0].execute(query, (stock_id,))
    stock = db[0].fetchone()
    if stock:
        return {"StockID": stock[0], "StockName": stock[1], "Quantity": stock[2], "CostPrice": stock[3],
                "SupplierID": stock[4], "Status": stock[5]}
    raise HTTPException(status_code=404, detail="Stock not found")

# ✅ Create Stock (Status is determined automatically)
@StockRouter.post("/stocks/")
async def create_stock(
    StockName: str = Form(...),
    Quantity: int = Form(...),
    CostPrice: float = Form(...),
    SupplierID: Optional[int] = Form(None),
    db=Depends(get_db)
):
    try:
        # Automatically determine stock status based on quantity
        Status = determine_stock_status(Quantity)

        db[0].execute(
            "INSERT INTO stocks (StockName, Quantity, CostPrice, SupplierID, Status) VALUES (%s, %s, %s, %s, %s)",
            (StockName, Quantity, CostPrice, SupplierID, Status)
        )
        db[1].commit()

        db[0].execute("SELECT LAST_INSERT_ID()")
        new_stock_id = db[0].fetchone()[0]

        return {
            "StockID": new_stock_id,
            "StockName": StockName,
            "Quantity": Quantity,
            "CostPrice": CostPrice,
            "SupplierID": SupplierID,
            "Status": Status,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# ✅ Update Stock (Status updates dynamically if Quantity is changed)
@StockRouter.put("/stocks/{stock_id}", response_model=dict)
async def update_stock(
    stock_id: int,
    stock_data: StockUpdate,
    db=Depends(get_db)
):
    # Check if the stock exists
    query_check_stock = "SELECT StockID, Quantity FROM stocks WHERE StockID = %s"
    db[0].execute(query_check_stock, (stock_id,))
    stock = db[0].fetchone()

    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")

    update_fields = []
    update_values = []
    
    new_quantity = stock[1]  # Default to current quantity
    
    if stock_data.StockName is not None:
        update_fields.append("StockName = %s")
        update_values.append(stock_data.StockName)

    if stock_data.Quantity is not None:
        new_quantity = stock_data.Quantity
        update_fields.append("Quantity = %s")
        update_values.append(new_quantity)

    if stock_data.CostPrice is not None:
        update_fields.append("CostPrice = %s")
        update_values.append(stock_data.CostPrice)

    if stock_data.SupplierID is not None:
        update_fields.append("SupplierID = %s")
        update_values.append(stock_data.SupplierID)

    # Automatically update status if quantity changes
    Status = determine_stock_status(new_quantity)
    update_fields.append("Status = %s")
    update_values.append(Status)

    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    update_query = f"UPDATE stocks SET {', '.join(update_fields)} WHERE StockID = %s"
    update_values.append(stock_id)

    db[0].execute(update_query, tuple(update_values))
    db[1].commit()

    return {"message": "Stock updated successfully", "new_status": Status}

# ✅ Delete Stock
@StockRouter.delete("/stocks/{stock_id}", response_model=dict)
async def delete_stock(
    stock_id: int,
    db=Depends(get_db)
):
    try:
        query_check_stock = "SELECT StockID FROM stocks WHERE StockID = %s"
        db[0].execute(query_check_stock, (stock_id,))
        stock = db[0].fetchone()

        if not stock:
            raise HTTPException(status_code=404, detail="Stock not found")

        query_delete_stock = "DELETE FROM stocks WHERE StockID = %s"
        db[0].execute(query_delete_stock, (stock_id,))
        db[1].commit()

        return {"message": "Stock deleted successfully"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    finally:
        db[0].close()
