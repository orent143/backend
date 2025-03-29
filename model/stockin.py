from fastapi import Depends, HTTPException, APIRouter
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime
import logging

StockRouter = APIRouter(tags=["Stock In"])

# Logger configuration
logger = logging.getLogger(__name__)


# Models
class DeductedTransaction(BaseModel):
    TransactionID: int
    QuantityDeducted: int
    TransactionDate: str

class StockItem(BaseModel):
    batch_number: str
    quantity: int
    expiration_date: Optional[str] = None
    SupplierName: Optional[str] = "Unknown"

class StockInRequest(BaseModel):
    ProductID: str
    Stocks: List[StockItem]

class ProductDetailsResponse(BaseModel):
    ProductID: int
    ProductName: str
    Quantity: Optional[int] = None
    ProcessType: Optional[str] = None
    Image: Optional[str] = None
    CurrentSupplier: Optional[str] = None
    Status: Optional[str] = None
    Threshold: Optional[int] = None
    StockDetails: List[StockItem]
    DeductedTransactions: Optional[List[DeductedTransaction]] = []

# ✅ Stock In Endpoint with Supplier Lookup
@StockRouter.post("/stockin/")
async def stock_in(request: StockInRequest, db=Depends(get_db)):
    try:
        # Validate product existence
        db[0].execute("SELECT ProductName FROM inventoryproduct WHERE id = %s", (request.ProductID,))
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        total_quantity_added = 0
        stock_list = []

        # Iterate over each stock item
        for stock in request.Stocks:
            total_quantity_added += stock.quantity

            # Fetch the supplier ID by name
            db[0].execute("SELECT id FROM suppliers WHERE SupplierName = %s", (stock.SupplierName,))
            supplier = db[0].fetchone()

            # Handle missing supplier
            if not supplier:
                raise HTTPException(status_code=404, detail=f"Supplier '{stock.SupplierName}' not found")

            supplier_id = supplier[0]

            # Handle expiration date
            exp_date = None
            if stock.expiration_date and stock.expiration_date != "0000-00-00":
                exp_date = datetime.strptime(stock.expiration_date, "%Y-%m-%d").date()

            # Insert into stock_details
            db[0].execute(
                """
                INSERT INTO stock_details (ProductID, batch_number, quantity, expiration_date, SupplierID) 
                VALUES (%s, %s, %s, %s, %s)
                """,
                (request.ProductID, stock.batch_number, stock.quantity, exp_date, supplier_id)
            )

            # Insert into inventory_transactions
            db[0].execute(
                """
                INSERT INTO inventory_transactions (ProductID, product_name, transaction_type, quantity)
                VALUES (%s, %s, 'Add', %s)
                """,
                (request.ProductID, product[0], stock.quantity)
            )

            stock_list.append({
                "batch_number": stock.batch_number,
                "quantity": stock.quantity,
                "expiration_date": stock.expiration_date,
                "SupplierName": stock.SupplierName
            })

        # Update inventory quantity
        db[0].execute(
            "UPDATE inventoryproduct SET Quantity = Quantity + %s WHERE id = %s",
            (total_quantity_added, request.ProductID)
        )

        db[1].commit()

        # Return full server response, including added stocks
        return {
            "message": "Stock added successfully",
            "ProductID": request.ProductID,
            "TotalQuantityAdded": total_quantity_added,
            "AddedStocks": stock_list
        }

    except Exception as e:
        logger.error(f"Error in stock_in: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")


# ✅ Get Product Details Endpoint
@StockRouter.get("/stockin/{product_id}", response_model=dict)
async def get_product_details(product_id: str, db=Depends(get_db)):
    """Get product details with consistent remaining quantity."""
    try:
        # Fetch product and supplier details
        db[0].execute("""
            SELECT 
                ip.id, 
                ip.ProductName, 
                ip.Quantity,    
                ip.ProcessType, 
                ip.Image, 
                ip.Threshold,  
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

        remaining_quantity = product[2]
        threshold = product[5] if product[5] else 5

        # Determine stock status
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
            "Threshold": threshold,
            "Status": status
        }

    except Exception as e:
        logger.error(f"Error in get_product_details: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# ✅ Get Stock Details with Transactions and Quantity Status
@StockRouter.get("/stockdetails/{product_id}", response_model=ProductDetailsResponse)
async def get_stock_details(product_id: str, db=Depends(get_db)):
    """Get detailed stock info with remaining quantity, transactions, supplier, and quantity status."""
    try:
        # Fetch product details with current supplier
        db[0].execute("""
            SELECT 
                ip.id, 
                ip.ProductName, 
                ip.Quantity,    
                ip.ProcessType, 
                ip.Image, 
                ip.Threshold,
                COALESCE(s.SupplierName, 'N/A') AS CurrentSupplier
            FROM inventoryproduct ip
            LEFT JOIN stock_details sd ON ip.id = sd.ProductID
            LEFT JOIN suppliers s ON sd.SupplierID = s.id
            WHERE ip.id = %s
            ORDER BY sd.created_at DESC 
            LIMIT 1
        """, (product_id,))

        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # Determine stock status
        remaining_quantity = product[2]
        threshold = product[5] if product[5] else 5

        if remaining_quantity <= 0:
            status = "Out of Stock"
        elif remaining_quantity <= threshold:
            status = "Low Stock"
        else:
            status = "In Stock"

        # Base URL for images
        base_url = "http://127.0.0.1:8000/uploads/products/"
        product_image = f"{base_url}{product[4]}" if product[4] else None

        # Fetch stock details
        db[0].execute("""
            SELECT 
                sd.batch_number,
                sd.quantity,
                sd.expiration_date,
                COALESCE(s.SupplierName, 'Unknown') AS SupplierName
            FROM stock_details sd
            LEFT JOIN suppliers s ON sd.SupplierID = s.id
            WHERE sd.ProductID = %s
            ORDER BY sd.created_at DESC
        """, (product_id,))

        stocks = db[0].fetchall()

        stock_list = [
            {
                "batch_number": stock[0],
                "quantity": stock[1],
                "expiration_date": stock[2].strftime('%Y-%m-%d') if stock[2] else None,
                "SupplierName": stock[3]
            }
            for stock in stocks
        ]

        # Fetch deducted transactions
        db[0].execute("""
            SELECT 
                it.id AS TransactionID, 
                it.quantity AS QuantityDeducted, 
                it.created_at AS TransactionDate
            FROM inventory_transactions it
            WHERE it.ProductID = %s AND it.transaction_type = 'Deduct'
            ORDER BY it.created_at DESC
        """, (product_id,))

        transactions = db[0].fetchall()

        deducted_transactions = [
            {
                "TransactionID": txn[0],
                "QuantityDeducted": txn[1],
                "TransactionDate": txn[2].strftime('%Y-%m-%d %H:%M:%S')
            }
            for txn in transactions
        ]

        # Return the complete response
        return {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": remaining_quantity,
            "ProcessType": product[3],
            "Image": product_image,
            "CurrentSupplier": product[6],
            "Threshold": threshold,
            "Status": status,
            "StockDetails": stock_list,
            "DeductedTransactions": deducted_transactions
        }

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
