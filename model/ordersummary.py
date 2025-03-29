from fastapi import APIRouter, Depends, HTTPException
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime

OrderSummaryRouter = APIRouter(tags=["OrderSummary"])

# Models
class OrderSummary(BaseModel):
    history_id: int
    customer_name: str
    total_items: int
    total_amount: float
    payment_method: str
    created_at: Optional[str]  # ✅ Updated to use `created_at`

class OrderHistoryDetail(BaseModel):
    history_id: int
    customer_name: str
    total_items: int
    total_amount: float
    payment_method: str
    created_at: Optional[str]  # ✅ Updated to use `created_at`
    items: List[dict]


# ✅ Get order history summary with `OrderDate`
@OrderSummaryRouter.get("/orders/history", response_model=List[OrderSummary])
async def get_order_history(db=Depends(get_db)):
    db[0].execute("""
        SELECT history_id, customer_name, total_items, 
               total_amount, payment_method, created_at
        FROM order_history
        ORDER BY created_at DESC
    """)

    history_orders = db[0].fetchall()

    return [
        {
            "history_id": row[0],
            "customer_name": row[1],
            "total_items": row[2],
            "total_amount": float(row[3]),
            "payment_method": row[4],
            "created_at": row[5].strftime("%Y-%m-%d %H:%M:%S") if row[5] else None
        }
        for row in history_orders
    ]

@OrderSummaryRouter.get("/orders/history/{history_id}", response_model=OrderHistoryDetail)
async def get_order_history_detail(history_id: int, db=Depends(get_db)):
    cursor, _ = db

    # Fetch order summary
    cursor.execute("""
        SELECT oh.history_id, oh.customer_name, oh.total_items, 
               oh.total_amount, oh.payment_method, oh.created_at
        FROM order_history oh
        WHERE oh.history_id = %s
    """, (history_id,))

    order = cursor.fetchone()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found in history")

    # Fetch products from `order_history_detail`
    cursor.execute("""
        SELECT od.product_id, od.product_name, od.quantity, od.product_price
        FROM order_history_detail od
        WHERE od.order_id = %s
    """, (history_id,))

    items = [
        {
            "product_id": row[0],
            "product_name": row[1],
            "quantity": row[2],
            "price": float(row[3])
        }
        for row in cursor.fetchall()
    ]

    return {
        "history_id": order[0],
        "customer_name": order[1],
        "total_items": order[2],
        "total_amount": float(order[3]),
        "payment_method": order[4],
        "created_at": order[5].strftime("%Y-%m-%d %H:%M:%S") if order[5] else None,
        "items": items
    }

# New Endpoint: Get daily total revenue
@OrderSummaryRouter.get("/orders/daily-revenue", response_model=dict)
async def get_daily_total_revenue(db=Depends(get_db)):
    # Get today's date in 'YYYY-MM-DD' format
    today_date = datetime.today().strftime('%Y-%m-%d')

    # Query for total sales today
    db[0].execute("""
        SELECT SUM(total_amount)
        FROM order_history
        WHERE DATE(created_at) = %s
    """, (today_date,))

    total_sales = db[0].fetchone()[0]

    return {"total_sales_today": float(total_sales) if total_sales else 0.0}