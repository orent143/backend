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

def log_activity(db, icon: str, title: str, status: str):
    try:
        db[0].execute(
            "INSERT INTO activity_logs (icon, title, time, status) VALUES (%s, %s, NOW(), %s)",
            (icon, title, status),
        )
        db[1].commit()
    except Exception as e:
        print(f"Failed to log activity: {e}")

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
        Status = determine_stock_status(Quantity)
        db[0].execute(
            "INSERT INTO stocks (StockName, Quantity, CostPrice, SupplierID, Status) VALUES (%s, %s, %s, %s, %s)",
            (StockName, Quantity, CostPrice, SupplierID, Status)
        )
        db[1].commit()
        db[0].execute("SELECT LAST_INSERT_ID()")
        new_stock_id = db[0].fetchone()[0]
        log_activity(db, "pi pi-box", f"New Stock added: {StockName} ", "Success")
        return {"StockID": new_stock_id, "StockName": StockName, "Quantity": Quantity, "CostPrice": CostPrice, "SupplierID": SupplierID, "Status": Status}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@StockRouter.put("/stocks/{stock_id}", response_model=dict)
async def update_stock(stock_id: int, stock_data: StockUpdate, db=Depends(get_db)):
    db[0].execute("SELECT StockName FROM stocks WHERE StockID = %s", (stock_id,))
    stock = db[0].fetchone()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    update_fields = []
    update_values = []
    if stock_data.StockName is not None:
        update_fields.append("StockName = %s")
        update_values.append(stock_data.StockName)
    if stock_data.Quantity is not None:
        update_fields.append("Quantity = %s")
        update_values.append(stock_data.Quantity)
        Status = determine_stock_status(stock_data.Quantity)
        update_fields.append("Status = %s")
        update_values.append(Status)
    if stock_data.CostPrice is not None:
        update_fields.append("CostPrice = %s")
        update_values.append(stock_data.CostPrice)
    if stock_data.SupplierID is not None:
        update_fields.append("SupplierID = %s")
        update_values.append(stock_data.SupplierID)
    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields provided for update")
    update_query = f"UPDATE stocks SET {', '.join(update_fields)} WHERE StockID = %s"
    update_values.append(stock_id)
    db[0].execute(update_query, tuple(update_values))
    db[1].commit()
    log_activity(db, "pi pi-pencil", f"Stock updated: {stock[0]}", "Success")
    return {"message": "Stock updated successfully"}

# ✅ Delete Stock

@StockRouter.delete("/stocks/{stock_id}", response_model=dict)
async def delete_stock(stock_id: int, db=Depends(get_db)):
    try:
        # Check if stock exists
        db[0].execute("SELECT StockName FROM stocks WHERE StockID = %s", (stock_id,))
        stock = db[0].fetchone()
        if not stock:
            raise HTTPException(status_code=404, detail="Stock not found")

        # Delete dependent records from stock_reports
        db[0].execute("DELETE FROM stock_reports WHERE StockID = %s", (stock_id,))
        db[0].execute("DELETE FROM stocks WHERE StockID = %s", (stock_id,))
        db[1].commit()

        log_activity(db, "pi pi-trash", f"Stock deleted: {stock[0]}", "Warning")
        return {"message": "Stock deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")



# ✅ Get Low Stock
@StockRouter.post("/stocks/low_stock")
async def get_low_stock(db=Depends(get_db)):
    try:
        # Fetch low stock items (Quantity <= 10)
        query = "SELECT StockID, StockName, Quantity, CostPrice, SupplierID, Status FROM stocks WHERE Quantity <= 10"
        db[0].execute(query)
        low_stock_items = db[0].fetchall()

        # If low stock items exist, insert them into stock_reports table
        if low_stock_items:
            # Record the current timestamp for the report date
            report_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S") 

            for item in low_stock_items:
                # Insert each low stock item into the stock_reports table
                db[0].execute(
                    "INSERT INTO stock_reports (ReportDate, StockID, StockName, Quantity, CostPrice, SupplierID, Status) "
                    "VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    (report_date, item[0], item[1], item[2], item[3], item[4], item[5])
                )
            
            db[1].commit()

            # Return the low stock items
            return [
                {
                    "StockID": item[0],
                    "StockName": item[1],
                    "Quantity": item[2],
                    "CostPrice": item[3],
                    "SupplierID": item[4],
                    "Status": item[5]
                }
                for item in low_stock_items
            ]
        else:
            return {"message": "No low stock items found"}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching low stock items: {str(e)}")

@StockRouter.get("/stocks/low_stock/total", response_model=dict)
async def get_total_low_stock(db=Depends(get_db)):
    try:
        query = "SELECT COUNT(*) FROM stocks WHERE Quantity <= 10"
        db[0].execute(query)
        total_low_stock = db[0].fetchone()[0] or 0  # Default to 0 if no items are low stock

        return {"total_low_stock": total_low_stock}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching total low stock: {str(e)}")

@StockRouter.get("/total_cost", response_model=dict)
async def get_total_cost(db=Depends(get_db)):
    query = "SELECT SUM(Quantity * CostPrice) FROM stocks"
    db[0].execute(query)
    total_cost = db[0].fetchone()[0] or 0.0  # Default to 0 if no data
    return {"total_cost": total_cost}


@StockRouter.get("/activity_logs", response_model=list)
async def get_activity_logs(db=Depends(get_db)):
    try:
        query = "SELECT LogID, icon, title, time, status FROM activity_logs ORDER BY time DESC"
        db[0].execute(query)
        logs = [
            {"LogID": log[0], "icon": log[1], "title": log[2], "time": log[3], "status": log[4]}
            for log in db[0].fetchall()
        ]
        return logs
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching activity logs: {str(e)}")