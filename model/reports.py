from fastapi import APIRouter, Depends, HTTPException, Query
from typing import Dict, List, Optional
from datetime import datetime
from model.db import get_db
import traceback  # Add this to log the full error trace

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
    print(f"Generating inventory report for: {report_date}")  # Debugging log

    if report_date:
        db[0].execute("""
            SELECT ReportID, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status, ReportDate
            FROM inventory_reports
            WHERE DATE(ReportDate) = %s
            ORDER BY ReportDate DESC
        """, (report_date,))
    else:
        db[0].execute("""
            SELECT ReportID, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status, ReportDate
            FROM inventory_reports
            ORDER BY ReportDate DESC
        """)

    products = db[0].fetchall()

    if not products:
        raise HTTPException(status_code=404, detail="No inventory report found")

    total_value = sum(product[3] * product[4] for product in products)  # Quantity * UnitPrice

    # Get the latest report date from the retrieved products
    latest_report_date = products[0][7].strftime("%Y-%m-%d %H:%M:%S") if products else None

    return {
        "date": latest_report_date,  # Include report date in response
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
                "ReportDate": product[7].strftime("%Y-%m-%d %H:%M:%S")
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
        print(traceback.format_exc())  # Log full error trace
        raise HTTPException(status_code=500, detail="Internal server error")
