from fastapi import APIRouter, Depends, HTTPException, Path, Body
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db

OrderSummaryRouter = APIRouter(tags=["OrderSummary"])

# Models
class OrderSummary(BaseModel):
    order_id: int
    customer_name: str
    total_items: int
    cash_on_hand: float
    total_amount: float
    change: float
    payment_method: str
    employee_id: Optional[int]
    OrderDate: str

class OrderHistoryDetail(BaseModel):
    order_id: int
    customer_name: str
    total_items: int
    cash_on_hand: float
    total_amount: float
    change: float
    payment_method: str
    employee_id: Optional[int]
    OrderDate: str
    items: List[dict]

# ✅ Get all orders summary
@OrderSummaryRouter.get("/orders", response_model=List[OrderSummary])
async def get_all_orders(db=Depends(get_db)):
    db[0].execute("""
    SELECT o.OrderID, 
           o.CustomerName, 
           COALESCE(COUNT(oi.ProductID), 0) AS total_items,
           MAX(o.CashOnHand) AS cash_on_hand,
           MAX(o.TotalAmount) AS total_amount,   
           (MAX(o.CashOnHand) - MAX(o.TotalAmount)) AS `change`,
           o.PaymentMethod,
           o.EmployeeID,
           o.OrderDate
    FROM orders o
    LEFT JOIN order_items oi ON o.OrderID = oi.OrderID
    GROUP BY o.OrderID, o.CustomerName, o.CashOnHand, o.TotalAmount, o.PaymentMethod, o.EmployeeID, o.OrderDate
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
            "change": float(row[5]),
            "payment_method": row[6],
            "employee_id": row[7] if row[7] is not None else None,
            "OrderDate": row[8].strftime("%Y-%m-%d %H:%M:%S") if row[8] else None
        }
        for row in orders
    ]

@OrderSummaryRouter.post("/orders/{order_id}/complete")
async def complete_order(order_id: int, db=Depends(get_db)):
    try:
        # Fetch order details
        db[0].execute(""" 
            SELECT o.OrderID, o.CustomerName, 
                   o.CashOnHand, o.TotalAmount, 
                   (o.CashOnHand - o.TotalAmount) AS `change`, 
                   o.PaymentMethod, o.EmployeeID
            FROM orders o
            WHERE o.OrderID = %s
        """, (order_id,))

        order = db[0].fetchone()

        if not order:
            raise HTTPException(status_code=404, detail="Order not found")

        order_id, customer_name, cash_on_hand, total_amount, change, payment_method, employee_id = order

        # Ensure employee_id is not required for cash payments
        if payment_method == "Cash":
            employee_id = None
        elif payment_method == "Tally" and not employee_id:
            raise HTTPException(status_code=400, detail="Employee ID is required for Tally payments")

        # Fetch order items with process type
        db[0].execute("""
            SELECT oi.ProductID, oi.Quantity, ip.ProductName, ip.ProcessType
            FROM order_items oi
            JOIN inventoryproduct ip ON oi.ProductID = ip.id
            WHERE oi.OrderID = %s
        """, (order_id,))

        order_items = db[0].fetchall()

        if not order_items:
            raise HTTPException(status_code=404, detail="No items found for this order")

        # Process Ready-Made products stock reduction
        for product_id, order_quantity, product_name, process_type in order_items:
            if process_type == "To Be Made":
                continue

            # Fetch available stock batches
            db[0].execute("""
                SELECT id, quantity, cost_price 
                FROM stock_details
                WHERE ProductID = %s AND quantity > 0
                ORDER BY expiration_date ASC, created_at ASC
            """, (product_id,))

            stock_batches = db[0].fetchall()

            if not stock_batches:
                raise HTTPException(status_code=400, 
                    detail=f"Insufficient stock for product {product_name}")

            remaining_quantity = order_quantity
            for batch_id, batch_quantity, cost_price in stock_batches:
                if remaining_quantity <= 0:
                    break

                deduction = min(batch_quantity, remaining_quantity)
                
                # Update stock details
                db[0].execute("""
                    UPDATE stock_details
                    SET quantity = quantity - %s
                    WHERE id = %s
                """, (deduction, batch_id))

                # Log inventory transaction
                db[0].execute("""
                    INSERT INTO inventory_transactions 
                    (product_name, transaction_type, quantity, cost_price)
                    VALUES (%s, 'Deduct', %s, %s)
                """, (product_name, deduction, cost_price))

                remaining_quantity -= deduction

        # Move to order history
        if payment_method == "Cash":
            db[0].execute("""
                INSERT INTO order_history 
                (order_id, customer_name, total_items, cash_on_hand, total_amount, 
                 `change`, payment_method, OrderDate)
                VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())
            """, (
                order_id, 
                customer_name, 
                len(order_items),
                cash_on_hand, 
                total_amount, 
                change, 
                payment_method
            ))
        else:
            db[0].execute("""
                INSERT INTO order_history 
                (order_id, customer_name, total_items, cash_on_hand, total_amount, 
                 `change`, payment_method, employee_id, OrderDate)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW())
            """, (
                order_id, 
                customer_name, 
                len(order_items),
                cash_on_hand, 
                total_amount, 
                change, 
                payment_method, 
                employee_id
            ))

        # Move order details to history
        db[0].execute("""
            INSERT INTO order_history_detail 
            (order_id, product_id, product_name, quantity, product_price)
            SELECT oi.OrderID, ip.id, ip.ProductName, oi.Quantity, ip.UnitPrice
            FROM order_items oi
            LEFT JOIN inventoryproduct ip ON oi.ProductID = ip.id
            WHERE oi.OrderID = %s
        """, (order_id,))

        # Clean up original order
        db[0].execute("DELETE FROM order_items WHERE OrderID = %s", (order_id,))
        db[0].execute("DELETE FROM orders WHERE OrderID = %s", (order_id,))
        
        db[1].commit()

        return {
            "message": "Order completed successfully",
            "order_id": order_id,
            "payment_method": payment_method,
            "employee_id": employee_id if payment_method == "Tally" else None
        }

    except HTTPException as http_err:
        db[1].rollback()
        raise http_err
    except Exception as e:
        db[1].rollback()
        raise HTTPException(status_code=500, detail=f"Error completing order: {str(e)}")

# ✅ Get order history summary with `OrderDate`
@OrderSummaryRouter.get("/orders/history", response_model=List[OrderSummary])
async def get_order_history(db=Depends(get_db)):
    db[0].execute("""
        SELECT order_id, customer_name, total_items, 
               cash_on_hand, total_amount, `change`,
               payment_method, employee_id, OrderDate
        FROM order_history
        ORDER BY OrderDate DESC
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
            "payment_method": row[6],
            "employee_id": row[7],
            "OrderDate": row[8].strftime("%Y-%m-%d %H:%M:%S") if row[8] else None  # ✅ Convert datetime to string
        }
        for row in history_orders
    ]

# ✅ Get order history details with `OrderDate`
@OrderSummaryRouter.get("/orders/history/{order_id}", response_model=OrderHistoryDetail)
async def get_order_history_detail(order_id: int, db=Depends(get_db)):
    # Fetch order summary with `OrderDate`
    db[0].execute("""
        SELECT oh.order_id, oh.customer_name, oh.total_items, 
               oh.cash_on_hand, oh.total_amount, oh.`change`,
               oh.payment_method, oh.employee_id, oh.OrderDate
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
            "price": float(row[3])
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
        "payment_method": order[6],
        "employee_id": order[7],
        "OrderDate": order[8].strftime("%Y-%m-%d %H:%M:%S") if order[8] else None,  # ✅ Convert datetime to string
        "items": items
    }
