from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
from model.db import get_db
from fastapi import Query, Body

OrderSummaryRouter = APIRouter(tags=["OrderSummary"])

# Order Item Model
class OrderItemResponse(BaseModel):
    product_id: int
    name: str
    quantity: int

# Order Summary Model with Items
class OrderSummaryResponse(BaseModel):
    order_id: int
    customer_name: str
    table_number: int
    order_date: str
    total_amount: float
    order_status: str
    items: List[OrderItemResponse]

class OrderStatusUpdateRequest(BaseModel):
    status: str

# Get all orders with item names
@OrderSummaryRouter.get("/orders", response_model=List[OrderSummaryResponse])
async def get_all_orders(db=Depends(get_db)):
    db[0].execute("SELECT OrderID, CustomerName, TableNumber, OrderDate, TotalAmount, COALESCE(OrderStatus, 'Pending') FROM orders")
    orders = db[0].fetchall()

    all_orders = []
    
    for order in orders:
        db[0].execute("""
            SELECT oi.ProductID, ip.ProductName, oi.Quantity 
            FROM order_items oi
            JOIN inventoryproduct ip ON oi.ProductID = ip.id
            WHERE oi.OrderID = %s
        """, (order[0],))
        items = db[0].fetchall()

        all_orders.append({
            "order_id": order[0],
            "customer_name": order[1],
            "table_number": order[2],
            "order_date": str(order[3]),
            "total_amount": float(order[4]),
            "order_status": order[5] if order[5] else "Pending",  # Ensure 'Pending' if NULL
            "items": [
                {"product_id": item[0], "name": item[1], "quantity": item[2]}
                for item in items
            ],
        })
    
    return all_orders
@OrderSummaryRouter.get("/orders/history", response_model=List[OrderSummaryResponse])
async def get_order_history(db=Depends(get_db)):
    db[0].execute("SELECT order_id, customer_name, table_number, order_date, total_amount, order_status FROM order_history")
    history_orders = db[0].fetchall()

    all_history_orders = []
    
    for order in history_orders:
        db[0].execute("""
            SELECT oi.ProductID, ip.ProductName, oi.Quantity 
            FROM order_items oi
            JOIN inventoryproduct ip ON oi.ProductID = ip.id
            WHERE oi.OrderID = %s
        """, (order[0],))
        items = db[0].fetchall()

        all_history_orders.append({
            "order_id": order[0],
            "customer_name": order[1],
            "table_number": order[2],
            "order_date": str(order[3]),
            "total_amount": float(order[4]),
            "order_status": order[5],
            "items": [
                {"product_id": item[0], "name": item[1], "quantity": item[2]}
                for item in items
            ],
        })
    
    return all_history_orders


# Get a specific order with item names
@OrderSummaryRouter.get("/orders/{order_id}", response_model=OrderSummaryResponse)
async def get_order_by_id(order_id: int, db=Depends(get_db)):
    db[0].execute("SELECT OrderID, CustomerName, TableNumber, OrderDate, TotalAmount, COALESCE(OrderStatus, 'Pending') FROM orders WHERE OrderID = %s", (order_id,))
    order = db[0].fetchone()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    db[0].execute("""
        SELECT oi.ProductID, ip.ProductName, oi.Quantity 
        FROM order_items oi
        JOIN inventoryproduct ip ON oi.ProductID = ip.id
        WHERE oi.OrderID = %s
    """, (order_id,))
    items = db[0].fetchall()

    return {
        "order_id": order[0],
        "customer_name": order[1],
        "table_number": order[2],
        "order_date": str(order[3]),
        "total_amount": float(order[4]),
        "order_status": order[5] if order[5] else "Pending",  # Ensure 'Pending' if NULL
        "items": [
            {"product_id": item[0], "name": item[1], "quantity": item[2]}
            for item in items
        ],
    }


# Update order status
@OrderSummaryRouter.put("/orders/{order_id}/status", response_model=OrderSummaryResponse)
async def update_order_status(order_id: int, request: OrderStatusUpdateRequest = Body(...), db=Depends(get_db)):
    allowed_statuses = ["Pending", "Preparing", "Completed", "Cancelled"]  
    if request.status not in allowed_statuses:
        raise HTTPException(status_code=400, detail="Invalid status")

    # Check if order exists
    db[0].execute("SELECT OrderID, CustomerName, TableNumber, OrderDate, TotalAmount FROM orders WHERE OrderID = %s", (order_id,))
    order = db[0].fetchone()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    # Update the order status
    db[0].execute("UPDATE orders SET OrderStatus = %s WHERE OrderID = %s", (request.status, order_id))
    db[1].commit()

    # If order is completed, move it to order history
    if request.status == "Completed":
        db[0].execute("""
            INSERT INTO order_history (order_id, customer_name, table_number, order_date, total_amount, order_status)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (order[0], order[1], order[2], order[3], order[4], request.status))
        db[1].commit()

    # Fetch the updated order
    db[0].execute("SELECT OrderID, CustomerName, TableNumber, OrderDate, TotalAmount, COALESCE(OrderStatus, 'Pending') FROM orders WHERE OrderID = %s", (order_id,))
    order = db[0].fetchone()

    # Fetch the order items
    db[0].execute("""
        SELECT oi.ProductID, ip.ProductName, oi.Quantity 
        FROM order_items oi
        JOIN inventoryproduct ip ON oi.ProductID = ip.id
        WHERE oi.OrderID = %s
    """, (order_id,))
    items = db[0].fetchall()

    return {
        "order_id": order[0],
        "customer_name": order[1],
        "table_number": order[2],
        "order_date": str(order[3]),
        "total_amount": float(order[4]),
        "order_status": order[5],  # Ensures the updated status is reflected
        "items": [
            {"product_id": item[0], "name": item[1], "quantity": item[2]}
            for item in items
        ],
    }

# Delete an order
@OrderSummaryRouter.delete("/orders/{order_id}")
async def delete_order(order_id: int, db=Depends(get_db)):
    db[0].execute("SELECT OrderID FROM orders WHERE OrderID = %s", (order_id,))
    if not db[0].fetchone():
        raise HTTPException(status_code=404, detail="Order not found")

    db[0].execute("DELETE FROM orders WHERE OrderID = %s", (order_id,))
    db[1].commit()

    return {"message": f"Order {order_id} deleted successfully"}
    


