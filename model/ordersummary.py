from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db
import json

OrderSummaryRouter = APIRouter(tags=["OrderSummary"])

# Models
class OrderSummary(BaseModel):
    order_id: int
    customer_name: str
    total_items: int
    cash_on_hand: float
    total_amount: float
    change: float


class OrderHistoryDetail(BaseModel):
    order_id: int
    customer_name: str
    total_items: int
    cash_on_hand: float
    total_amount: float
    change: float
    items: List[dict]

# Get all orders summary
@OrderSummaryRouter.get("/orders", response_model=List[OrderSummary])
async def get_all_orders(db=Depends(get_db)):
    db[0].execute("""
    SELECT o.OrderID, 
           o.CustomerName, 
           COALESCE(COUNT(oi.ProductID), 0) AS total_items,
           MAX(o.CashOnHand) AS cash_on_hand,
           MAX(o.TotalAmount) AS total_amount,   
           (MAX(o.CashOnHand) - MAX(o.TotalAmount)) AS `change`
    FROM orders o
    LEFT JOIN order_items oi ON o.OrderID = oi.OrderID
    GROUP BY o.OrderID, o.CustomerName, o.CashOnHand, o.TotalAmount
    ORDER BY o.OrderID DESC
    """)

    orders = db[0].fetchall()

    return [
        {
            "order_id": row[0],
            "customer_name": row[1],
            "total_items": row[2],
            "cash_on_hand": float(row[3]),
            "total_amount": float(row[4]),
            "change": float(row[5])
        }
        for row in orders
    ]

@OrderSummaryRouter.post("/orders/{order_id}/complete")
async def complete_order(order_id: int, db=Depends(get_db)):
    # Fetch order summary
    db[0].execute("""
        SELECT o.OrderID, o.CustomerName, 
               o.CashOnHand, o.TotalAmount, 
               (o.CashOnHand - o.TotalAmount) AS `change`
        FROM orders o
        WHERE o.OrderID = %s
    """, (order_id,))
    
    order = db[0].fetchone()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    # Move order summary to history
    db[0].execute("""
        INSERT INTO order_history 
        (order_id, customer_name, total_items, cash_on_hand, total_amount, `change`)
        VALUES (%s, %s, 
            (SELECT COUNT(*) FROM order_items WHERE OrderID = %s), 
            %s, %s, %s)
    """, (order[0], order[1], order[0], order[2], order[3], order[4]))

    # Move individual order items to history detail with price
    db[0].execute("""
        INSERT INTO order_history_detail (order_id, product_id, product_name, quantity, product_price)
        SELECT oi.OrderID, ip.id, ip.ProductName, oi.Quantity, ip.UnitPrice
        FROM order_items oi
        LEFT JOIN inventoryproduct ip ON oi.ProductID = ip.id
        WHERE oi.OrderID = %s
    """, (order_id,))

    # Delete the order from the current tables
    db[0].execute("DELETE FROM order_items WHERE OrderID = %s", (order_id,))
    db[0].execute("DELETE FROM orders WHERE OrderID = %s", (order_id,))
    
    db[1].commit()

    return {"message": f"Order {order_id} marked as completed and moved to history with details"}


# Get order history summary
@OrderSummaryRouter.get("/orders/history", response_model=List[OrderSummary])
async def get_order_history(db=Depends(get_db)):
    db[0].execute("""
        SELECT order_id, customer_name, total_items, cash_on_hand, total_amount, `change`
        FROM order_history
        ORDER BY order_id DESC
    """)
    
    history_orders = db[0].fetchall()

    return [
        {
            "order_id": row[0],
            "customer_name": row[1],
            "total_items": row[2],
            "cash_on_hand": float(row[3]),
            "total_amount": float(row[4]),
            "change": float(row[5]),
        }
        for row in history_orders
    ]

# ✅ Get order history details with specific product price
@OrderSummaryRouter.get("/orders/history/{order_id}", response_model=OrderHistoryDetail)
async def get_order_history_detail(order_id: int, db=Depends(get_db)):
    # Fetch order summary
    db[0].execute("""
        SELECT oh.order_id, oh.customer_name, oh.total_items, 
               oh.cash_on_hand, oh.total_amount, oh.`change`
        FROM order_history oh
        WHERE oh.order_id = %s
    """, (order_id,))
    
    order = db[0].fetchone()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found in history")

    # Fetch order items with product price
    db[0].execute("""
        SELECT product_id, product_name, quantity, product_price
        FROM order_history_detail
        WHERE order_id = %s
    """, (order_id,))
    
    items = [
        {
            "product_id": row[0],
            "name": row[1],
            "quantity": row[2],
            "price": float(row[3])  # ✅ Include product price
        }
        for row in db[0].fetchall()
    ]

    return {
        "order_id": order[0],
        "customer_name": order[1],
        "total_items": order[2],
        "cash_on_hand": float(order[3]),
        "total_amount": float(order[4]),
        "change": float(order[5]),
        "items": items
    }
