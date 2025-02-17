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
