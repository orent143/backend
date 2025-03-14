from fastapi import APIRouter, Depends, HTTPException, Query 
from typing import Dict, List, Optional
from datetime import datetime
from model.db import get_db
import traceback  

ReportRouter = APIRouter(tags=["Reports"])

def determine_status(quantity: int) -> str:
    """Determine stock status based on quantity."""
    if quantity == 0:
        return "Out of Stock"
    elif quantity <= 10:
        return "Low Stock"
    else:
        return "In Stock"

def generate_inventory_report(db, report_date: Optional[str] = None) -> Dict:
    """Fetch all inventory data for a given report date or the latest available report."""
    print(f"Generating inventory report for: {report_date}") 

    if report_date:
        db[0].execute("""
            SELECT ReportID, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status, ReportDate, Image
            FROM inventory_reports
            WHERE DATE(ReportDate) = %s
            ORDER BY ReportDate DESC
        """, (report_date,))
    else:
        db[0].execute("""
            SELECT ReportID, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status, ReportDate, Image
            FROM inventory_reports
            ORDER BY ReportDate DESC
        """)

    products = db[0].fetchall()

    if not products:
        raise HTTPException(status_code=404, detail="No inventory report found")

    total_value = sum(product[3] * product[4] for product in products)  

    latest_report_date = products[0][7].strftime("%Y-%m-%d %H:%M:%S") if products else None

    return {
        "date": latest_report_date,  
        "total_items": len(products),
        "total_value": total_value,
        "items": [
            {
                "ReportID": product[0],
                "ProductID": product[1],
                "ProductName": product[2],
                "Quantity": product[3],
                "UnitPrice": float(product[4]),
                "CategoryID": product[5],
                "Status": product[6],
                "ReportDate": product[7].strftime("%Y-%m-%d %H:%M:%S"),
                "Image": f"/uploads/products/{product[8]}" if product[8] else None,
            }
            for product in products
        ]
    }

@ReportRouter.get("/inventory_report", response_model=Dict)
async def get_inventory_report(
    date: Optional[str] = Query(None, description="Filter reports by date (YYYY-MM-DD)"),
    db: List = Depends(get_db)
):
    try:
        return generate_inventory_report(db, date)
    except HTTPException as e:
        raise e
    except Exception as e:
        print(traceback.format_exc())  
        raise HTTPException(status_code=500, detail="Internal server error")

@ReportRouter.get("/low_stock_report", response_model=Dict)
async def get_low_stock_report(
    date: Optional[str] = Query(None, description="Filter reports by date (YYYY-MM-DD)"),
    db: List = Depends(get_db)
):
    try:
        print(f"Generating low stock report for: {date}")  

        if date:
            db[0].execute("""
                SELECT ReportID, StockID, StockName, Quantity, CostPrice, SupplierID, Status, ReportDate, Image
                FROM stock_reports
                WHERE DATE(ReportDate) = %s AND Quantity <= 10
                ORDER BY ReportDate DESC
            """, (date,))
        else:
            db[0].execute("""
                SELECT ReportID, StockID, StockName, Quantity, CostPrice, SupplierID, Status, ReportDate, Image
                FROM stock_reports
                WHERE Quantity <= 10
                ORDER BY ReportDate DESC
            """)

        low_stock_items = db[0].fetchall()

        if not low_stock_items:
            raise HTTPException(status_code=404, detail="No low stock report found")

        total_value = sum(item[3] * item[4] for item in low_stock_items)  

        latest_report_date = low_stock_items[0][7].strftime("%Y-%m-%d %H:%M:%S") if low_stock_items else None

        return {
            "date": latest_report_date,  
            "total_items": len(low_stock_items),
            "total_value": total_value,
            "items": [
                {
                    "ReportID": item[0],
                    "StockID": item[1],
                    "StockName": item[2],
                    "Quantity": item[3],
                    "CostPrice": float(item[4]),
                    "SupplierID": item[5],
                    "Status": item[6],
                    "ReportDate": item[7].strftime("%Y-%m-%d %H:%M:%S"),
                    "Image": f"/uploads/stocks/{item[8]}" if item[8] else None,
                }
                for item in low_stock_items
            ]
        }

    except HTTPException as e:
        raise e
    except Exception as e:
        print(traceback.format_exc())  
        raise HTTPException(status_code=500, detail="Internal server error")
