from fastapi import Depends, HTTPException, APIRouter
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime
import logging

StockRouter = APIRouter(tags=["Stock In"])


class StockItem(BaseModel):
    batch_number: str
    quantity: int
    expiration_date: str
    SupplierID: Optional[int] = None


class StockInRequest(BaseModel):
    ProductID: str
    Stocks: List[StockItem]


logger = logging.getLogger(__name__)


@StockRouter.post("/stockin/")
async def stock_in(request: StockInRequest, db=Depends(get_db)):
    try:
        db[0].execute("SELECT ProductName FROM inventoryproduct WHERE id = %s", (request.ProductID,))
        product = db[0].fetchone()
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        total_quantity_added = 0
        for stock in request.Stocks:
            total_quantity_added += stock.quantity

            exp_date = None if not stock.expiration_date or stock.expiration_date == "0000-00-00" else datetime.strptime(stock.expiration_date, "%Y-%m-%d").date()

            # Insert into stock_details table
            db[0].execute(
                """
                INSERT INTO stock_details (ProductID, batch_number, quantity, expiration_date, SupplierID) 
                VALUES (%s, %s, %s, %s, %s)
                """,
                (request.ProductID, stock.batch_number, stock.quantity, exp_date, stock.SupplierID)
            )

            # Insert transaction into inventory_transactions
            db[0].execute(
                """
                INSERT INTO inventory_transactions (ProductID, product_name, transaction_type, quantity)
                VALUES (%s, %s, 'Add', %s)
                """,
                (request.ProductID, product[0], stock.quantity)
            )

        # Update the quantity in inventoryproduct by adding only the newly added stock
        db[0].execute("UPDATE inventoryproduct SET Quantity = Quantity + %s WHERE id = %s", (total_quantity_added, request.ProductID))
        db[1].commit()

        return {"message": "Stock added successfully", "ProductID": request.ProductID, "TotalQuantityAdded": total_quantity_added}

    except Exception as e:
        logger.error(f"Error in stock_in: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@StockRouter.get("/stockin/{product_id}", response_model=dict)
async def get_product_details(product_id: str, db=Depends(get_db)):
    """Get product details with consistent remaining quantity."""
    try:
        db[0].execute("""
            SELECT 
                ip.id, 
                ip.ProductName, 
                ip.Quantity,    -- ✅ Pulling the quantity directly from inventoryproduct
                ip.ProcessType, 
                ip.Image, 
                ip.Threshold,  -- Fetch the threshold value for the product
                COALESCE(s.SupplierName, 'N/A') AS SupplierName
            FROM inventoryproduct ip
            LEFT JOIN stock_details sd ON ip.id = sd.ProductID
            LEFT JOIN suppliers s ON sd.SupplierID = s.id
            WHERE ip.id = %s
            ORDER BY sd.created_at DESC LIMIT 1
        """, (product_id,))

        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # Extract values
        remaining_quantity = product[2]
        threshold = product[5] if product[5] is not None else 5  # Default threshold to 5 if not set

        # Determine stock status based on threshold and remaining quantity
        if remaining_quantity <= 0:
            status = "Out of Stock"
        elif remaining_quantity <= threshold:
            status = "Low Stock"
        else:
            status = "In Stock"

        base_url = "http://127.0.0.1:8000/uploads/products/"

        return {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": remaining_quantity,
            "ProcessType": product[3],
            "Image": f"{base_url}{product[4]}" if product[4] else None,
            "CurrentSupplier": product[6],
            "Threshold": threshold,  # Return Threshold in the response
            "Status": status
        }

    except Exception as e:
        logger.error(f"Error in get_product_details: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")



@StockRouter.get("/stockdetails/{product_id}", response_model=dict)
async def get_stock_details(product_id: str, db=Depends(get_db)):
    """Get detailed stock info with remaining quantity and basic product details."""
    try:
        # Fetch product details from the inventoryproduct table
        db[0].execute("""
            SELECT 
                ip.id, 
                ip.ProductName, 
                ip.Quantity,    -- Pulling the quantity directly from inventoryproduct
                ip.ProcessType, 
                ip.Image, 
                ip.Threshold,  -- Fetch the threshold value for the product
                COALESCE(s.SupplierName, 'N/A') AS SupplierName
            FROM inventoryproduct ip
            LEFT JOIN stock_details sd ON ip.id = sd.ProductID
            LEFT JOIN suppliers s ON sd.SupplierID = s.id
            WHERE ip.id = %s
            GROUP BY ip.id, ip.ProductName, ip.Quantity, ip.ProcessType, ip.Image, s.SupplierName
            ORDER BY sd.created_at DESC
        """, (product_id,))

        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # Extract values
        remaining_quantity = product[2]
        threshold = product[5]  # Get the threshold value from the database

        base_url = "http://127.0.0.1:8000/uploads/products/"

        # Fetch current stock details from stock_details table
        db[0].execute("""
            SELECT 
                sd.id,
                sd.batch_number,
                sd.quantity,
                sd.expiration_date,
                sd.created_at,
                COALESCE(s.SupplierName, 'Unknown') AS SupplierName
            FROM stock_details sd
            LEFT JOIN suppliers s ON sd.SupplierID = s.id
            WHERE sd.ProductID = %s
            ORDER BY sd.created_at DESC
        """, (product_id,))

        stocks = db[0].fetchall()

        # Prepare stock list
        stock_list = [
            {
                "id": stock[0],
                "batch_number": stock[1],
                "quantity": stock[2],
                "expiration_date": stock[3].strftime('%Y-%m-%d') if stock[3] else None,
                "created_at": stock[4].strftime('%Y-%m-%d %H:%M:%S'),
                "SupplierName": stock[5] or "Unknown"
            }
            for stock in stocks
        ]

        # Fetch deducted transactions from inventory_transactions table
        db[0].execute("""
            SELECT 
                it.id,
                it.quantity,
                it.transaction_type,
                it.created_at
            FROM inventory_transactions it
            WHERE it.ProductID = %s
            AND it.transaction_type = 'Deduct'
            ORDER BY it.created_at DESC
        """, (product_id,))

        deducted_list = [
            {
                "TransactionID": trans[0],
                "QuantityDeducted": trans[1],
                "TransactionDate": trans[3].strftime('%Y-%m-%d %H:%M:%S')
            }
            for trans in db[0].fetchall()
        ]

        # Determine stock status based on threshold and remaining quantity
        if remaining_quantity <= 0:
            status = "Out of Stock"
        elif remaining_quantity <= threshold:
            status = "Low Stock"
        else:
            status = "In Stock"

        return {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": remaining_quantity,
            "ProcessType": product[3],
            "Image": f"{base_url}{product[4]}" if product[4] else None,
            "CurrentSupplier": product[6],
            "Status": status,
            "StockDetails": stock_list,
            "DeductedTransactions": deducted_list
        }

    except Exception as e:
        logger.error(f"Error in get_stock_details: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

    
@StockRouter.get("/inventory-transactions", response_model=list)
async def get_inventory_transactions(db=Depends(get_db)):
    """Fetch all inventory transactions, including stock-in and deducted."""
    try:
        db[0].execute("""
            SELECT id, product_name, transaction_type, quantity, created_at
            FROM inventory_transactions
            WHERE transaction_type IN ('StockIn', 'Deduct')  -- Include both types
            ORDER BY created_at DESC
        """)
        
        transactions = db[0].fetchall()
        
        # Format the transactions data
        return [
            {
                "id": t[0],
                "product_name": t[1],
                "transaction_type": t[2],
                "quantity": t[3],
                "created_at": t[4].strftime("%Y-%m-%d %H:%M:%S")
            }
            for t in transactions
        ]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching transactions: {str(e)}")
