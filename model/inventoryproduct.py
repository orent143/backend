from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File, Request
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
import os
import shutil
from datetime import datetime
from uuid import uuid4

UPLOAD_DIR = "uploads/products"
os.makedirs(UPLOAD_DIR, exist_ok=True)

InventoryRouter = APIRouter(tags=["Inventory"])

class ProductUpdate(BaseModel):
    ProductName: Optional[str] = None
    Quantity: Optional[int] = None
    UnitPrice: Optional[float] = None
    CategoryID: Optional[int] = None
    Threshold: Optional[int] = None  # ✅ Added threshold field

class StockItem(BaseModel):
    stock_location: str
    batch_number: str
    quantity: int
    expiration_date: str
    cost_price: float
    SupplierID: Optional[int] = None  # Add SupplierID

class StockInRequest(BaseModel):
    ProductID: str
    Stocks: List[StockItem]

def determine_status(quantity: Optional[int], process_type: str, threshold: Optional[int] = None) -> str:
    """Determine the product status based on process type and threshold."""
    # Default None quantity to 0 for consistent status evaluation
    quantity = quantity if quantity is not None else 0
    
    if process_type == "To Be Made":
        return "Available"  # Always available for "To Be Made"

    if process_type == "Ready-Made":
        if quantity == 0:
            return "Out of Stock"
        elif threshold is not None and quantity <= threshold:
            return "Low Stock"
        else:
            return "In Stock"
    
    return "Unknown"


def generate_unique_id():
    return str(uuid4())

def log_activity(db, icon: str, title: str, status: str):
    try:
        db[0].execute(
            "INSERT INTO activity_logs (icon, title, time, status) VALUES (%s, %s, NOW(), %s)",
            (icon, title, status),
        )
        db[1].commit()
    except Exception as e:
        print(f"Failed to log activity: {e}")

def log_product_transaction(db, product_id: str, product_name: str, transaction_type: str, 
                          process_type: str, unit_price: float, category_id: Optional[int] = None):
    try:
        db[0].execute("""
            INSERT INTO product_transactions 
            (product_id, product_name, transaction_type, process_type, unit_price, category_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (product_id, product_name, transaction_type, process_type, unit_price, category_id))
        db[1].commit()
    except Exception as e:
        print(f"Failed to log product transaction: {e}")
        raise

@InventoryRouter.get("/inventoryproducts/all", response_model=list)
async def get_all_inventory_products(request: Request, db=Depends(get_db)):
    base_url = str(request.base_url)

    # Add ORDER BY id to ensure products are sorted by ProductID
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType, Threshold, Image FROM inventoryproduct ORDER BY id")
    products = db[0].fetchall()

    return [
        {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "ProcessType": product[5],
            "Threshold": product[6],
            "Status": determine_status(product[2], product[5], product[6]),
            "Image": f"{base_url}uploads/products/{product[7]}" if product[7] else None
        }
        for product in products
    ]


@InventoryRouter.get("/inventoryproducts/filter", response_model=list)
async def filter_inventory_products(
    request: Request,
    process_type: Optional[str] = None,
    threshold: Optional[int] = None,  # Optional threshold filter
    db=Depends(get_db)
):
    # Validate process type
    if process_type not in ["Ready-Made", "To Be Made"]:
        raise HTTPException(status_code=400, detail="Invalid Process Type")

    # Base URL for image paths
    base_url = str(request.base_url)

    # Construct the SQL query
    query = "SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType, Threshold, Image FROM inventoryproduct WHERE ProcessType = %s"
    params = [process_type]

    # Add threshold filter if provided
    if threshold is not None:
        query += " AND Threshold <= %s"
        params.append(threshold)

    db[0].execute(query, tuple(params))
    products = db[0].fetchall()

    return [
        {
            "id": product[0],
            "ProductName": product[1],
            "Quantity": float('inf') if product[5] == "To Be Made" else product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "ProcessType": product[5],
            "Threshold": product[6],
            "Status": "Available" if product[5] == "To Be Made" else determine_status(product[2], product[5], product[6]),
            "Image": f"{base_url}uploads/products/{product[7]}" if product[7] else None
        }
        for product in products
    ]

@InventoryRouter.get("/inventoryproduct/{product_id}", response_model=dict)
async def read_inventory_product(product_id: str, db=Depends(get_db)):
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType FROM inventoryproduct WHERE id = %s", (product_id,))
    product = db[0].fetchone()

    if product:
        return {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": float('inf') if product[5] == "To Be Made" else product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "Status": "Available" if product[5] == "To Be Made" else determine_status(product[2], product[5])
        }
    
    raise HTTPException(status_code=404, detail="Product not found")

@InventoryRouter.post("/inventoryproduct/")
async def create_inventory_product(
    request: Request,
    ProductID: str = Form(...),
    ProductName: str = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    ProcessType: str = Form(...),
    Threshold: Optional[int] = Form(None),  # ✅ Threshold parameter only
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db),
):
    try:
        if ProcessType == "Ready-Made" and Threshold is None:
            raise HTTPException(status_code=400, detail="Threshold required for Ready-Made products")

        image_filename = None

        if ProcessType not in ["Ready-Made", "To Be Made"]:
            raise HTTPException(status_code=400, detail="Invalid Process Type")

        if Image:
            file_extension = Image.filename.split(".")[-1]
            image_filename = f"{ProductID}_{ProductName.replace(' ', '_').replace('/', '_')}.{file_extension}"
            file_path = os.path.join(UPLOAD_DIR, image_filename)
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(Image.file, buffer)

        # Set status based on ProcessType and Threshold
        status = determine_status(None, ProcessType, Threshold)

        # Insert product into the database with threshold
        db[0].execute(
            """INSERT INTO inventoryproduct 
            (id, ProductName, UnitPrice, `CategoryID (FK)`, ProcessType, Threshold, Image, Status) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""",
            (ProductID, ProductName, UnitPrice, CategoryID, ProcessType, Threshold, image_filename, status)
        )
        db[1].commit()

        base_url = str(request.base_url)
        image_url = f"{base_url}uploads/products/{image_filename}" if image_filename else None

        return {
            "ProductID": ProductID,
            "ProductName": ProductName,
            "UnitPrice": UnitPrice,
            "CategoryID": CategoryID,
            "ProcessType": ProcessType,
            "Threshold": Threshold,
            "Status": status,
            "Image": image_url
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

        
@InventoryRouter.put("/inventoryproduct/{product_id}", response_model=dict)
async def update_inventory_product(
    product_id: str,
    ProductName: Optional[str] = Form(None),
    UnitPrice: Optional[float] = Form(None),
    CategoryID: Optional[int] = Form(None),
    Threshold: Optional[int] = Form(None),  # ✅ Threshold only
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db),
):
    try:
        db[0].execute(
            "SELECT ProductName, UnitPrice, `CategoryID (FK)`, Threshold, ProcessType, Image FROM inventoryproduct WHERE id = %s",
            (product_id,),
        )
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        update_fields = []
        update_values = []
        image_filename = product[5]

        if ProductName is not None:
            update_fields.append("ProductName = %s")
            update_values.append(ProductName)

        if UnitPrice is not None:
            update_fields.append("UnitPrice = %s")
            update_values.append(UnitPrice)

        if CategoryID is not None:
            update_fields.append("`CategoryID (FK)` = %s")
            update_values.append(CategoryID)

        if Threshold is not None:
            update_fields.append("Threshold = %s")
            update_values.append(Threshold)

        if Image:
            file_extension = Image.filename.split(".")[-1]
            image_filename = f"{ProductName.replace(' ', '_')}_{int(datetime.utcnow().timestamp())}.{file_extension}"
            file_path = os.path.join(UPLOAD_DIR, image_filename)

            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(Image.file, buffer)

            if product[5]:
                old_image_path = os.path.join(UPLOAD_DIR, product[5])
                if os.path.exists(old_image_path):
                    os.remove(old_image_path)

            update_fields.append("Image = %s")
            update_values.append(image_filename)

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields provided for update")

        # Update status based on process type and threshold
        status = determine_status(None, product[4], Threshold)
        update_fields.append("Status = %s")
        update_values.append(status)

        update_query = f"UPDATE inventoryproduct SET {', '.join(update_fields)} WHERE id = %s"
        update_values.append(product_id)

        db[0].execute(update_query, tuple(update_values))
        db[1].commit()

        log_activity(db, "pi pi-pencil", f"Product updated: {ProductName or product[0]}", "Updated")

        return {
            "message": "Product updated successfully",
            "Image": f"/uploads/products/{image_filename}" if image_filename else None,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@InventoryRouter.delete("/inventoryproduct/{product_id}", response_model=dict)
async def delete_inventory_product(product_id: str, db=Depends(get_db)):
    try:
        # Get product details before deletion
        db[0].execute("""
            SELECT ProductName, ProcessType, UnitPrice, `CategoryID (FK)` 
            FROM inventoryproduct 
            WHERE id = %s
        """, (product_id,))
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # Delete related records
        db[0].execute("DELETE FROM stock_details WHERE ProductID = %s", (product_id,))
        db[0].execute("DELETE FROM inventoryproduct WHERE id = %s", (product_id,))

        # Log the transaction
        log_product_transaction(
            db=db,
            product_id=product_id,
            product_name=product[0],
            transaction_type="Delete",
            process_type=product[1],
            unit_price=product[2],
            category_id=product[3]
        )

        db[1].commit()
        log_activity(db, "pi pi-trash", f"Product deleted: {product[0]}", "Deleted")
        
        return {"message": "Product deleted successfully"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")


@InventoryRouter.post("/inventorysummary", response_model=list)
async def post_inventory_summary(db=Depends(get_db)):
    try:
        report_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  

        db[0].execute(
            "INSERT INTO reports (ReportType, ReportName, ReportDate) VALUES (%s, %s, %s)",
            ("Daily", "Inventory Summary", report_date)
        )
        db[1].commit()

        db[0].execute("SELECT LAST_INSERT_ID()")
        report_id = db[0].fetchone()[0]  

        db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, Image FROM inventoryproduct")
        products = db[0].fetchall()

        for product in products:
            product_id, product_name, quantity, unit_price, category_id, image = product
            quantity = quantity if quantity is not None else 0
            unit_price = unit_price if unit_price is not None else 0.0
            status = determine_status(quantity)

            db[0].execute(
                """
                INSERT INTO inventory_reports 
                (ReportDate, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status, Image) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (report_date, product_id, product_name, quantity, unit_price, category_id, status, image)
            )

        db[1].commit()

        log_activity(db, "pi pi-chart-line", "Inventory summary generated", "Success")

        return [
            {
                "id": product[0],
                "ProductName": product[1],
                "Quantity": product[2] if product[2] is not None else 0,
                "UnitPrice": product[3] if product[3] is not None else 0.0,
                "CategoryID": product[4],
                "Status": determine_status(product[2] if product[2] is not None else 0),
                "Image": f"/uploads/products/{product[5]}" if product[5] else None
            }
            for product in products
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating inventory summary: {str(e)}")

@InventoryRouter.get("/activity_logs", response_model=list)
async def get_activity_logs(db=Depends(get_db)):
    db[0].execute("SELECT id, icon, title, time, status FROM activity_logs ORDER BY time DESC LIMIT 10")
    logs = db[0].fetchall()

    return [
        {
            "id": log[0],
            "icon": log[1],
            "title": log[2],
            "time": log[3].strftime("%Y-%m-%d %H:%M:%S"),
            "status": log[4]
        }
        for log in logs
    ]

@InventoryRouter.get("/product_transactions", response_model=list)
async def get_product_transactions(db=Depends(get_db)):
    """Fetch all product transactions."""
    try:
        db[0].execute("""
            SELECT pt.id, pt.product_id, pt.product_name, pt.transaction_type, 
                   pt.process_type, pt.unit_price, pt.category_id, pt.created_at
            FROM product_transactions pt
            ORDER BY pt.created_at DESC
        """)
        
        transactions = db[0].fetchall()
        
        return [
            {
                "id": t[0],
                "product_id": t[1],
                "product_name": t[2],
                "transaction_type": t[3],
                "process_type": t[4],
                "unit_price": float(t[5]),
                "category_id": t[6],
                "created_at": t[7].strftime("%Y-%m-%d %H:%M:%S")
            }
            for t in transactions
        ]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching transactions: {str(e)}")
    
@InventoryRouter.get("/total-products", response_model=dict)
async def get_total_products(db=Depends(get_db)):
    """Fetch total count of products in the inventory."""
    try:
        # SQL query to count all products in the inventory
        db[0].execute("""SELECT COUNT(*) FROM inventoryproduct""")
        
        # Fetch the count
        total_products = db[0].fetchone()[0]

        # Return the result as a dictionary
        return {"total_products": total_products}

    except Exception as e:
        # Log and raise an error in case of any issues
        logger.error(f"Error fetching total product count: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@InventoryRouter.get("/low-stock-total", response_model=dict)
async def get_total_low_stock(db=Depends(get_db)):
    """Fetch total count of products that are in low stock, excluding 'To Be Made' products."""
    try:
        # SQL query to count products that are in low stock and exclude 'To Be Made' products
        db[0].execute("""
            SELECT COUNT(*) 
            FROM inventoryproduct
            WHERE ProcessType = 'Ready-Made' 
            AND Quantity <= Threshold
        """)
        
        # Fetch the count
        low_stock_count = db[0].fetchone()[0]

        # Return the result as a dictionary
        return {"total_low_stock": low_stock_count}

    except Exception as e:
        # Log and raise an error in case of any issues
        logger.error(f"Error fetching total low stock count: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
