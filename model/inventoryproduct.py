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

def determine_status(quantity: Optional[int]) -> str:
    if quantity is None:
        return "Unknown"  # Or "Not Available", depending on your preference
    if quantity == 0:
        return "Out of Stock"
    elif quantity <= 10:
        return "Low Stock"
    else:
        return "In Stock"

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

    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType, Image FROM inventoryproduct")
    products = db[0].fetchall()

    return [
        {
            "ProductID": product[0],
            "ProductName": product[1],
            "Quantity": product[2] if product[5] != "To Be Made" else None,
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "ProcessType": product[5],
            "Status": determine_status(product[2]) if product[5] != "To Be Made" else "To Be Made",
            "Image": f"{base_url}uploads/products/{product[6]}" if product[6] else None
        }
        for product in products
    ]

@InventoryRouter.get("/inventoryproducts/filter", response_model=list)
async def filter_inventory_products(request: Request, process_type: Optional[str] = None, db=Depends(get_db)):
    """ Fetch products filtered by Process Type (Ready-Made or To Be Made). """
    if process_type not in ["Ready-Made", "To Be Made"]:
        raise HTTPException(status_code=400, detail="Invalid Process Type")

    base_url = str(request.base_url)
    
    db[0].execute(
        "SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType, Image FROM inventoryproduct WHERE ProcessType = %s",
        (process_type,)
    )
    products = db[0].fetchall()

    return [
        {
            "id": product[0],
            "ProductName": product[1],
            "Quantity": product[2] if product[5] != "To Be Made" else None,
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "ProcessType": product[5],
            "Status": determine_status(product[2]) if product[5] != "To Be Made" else "To Be Made",
            "Image": f"{base_url}uploads/products/{product[6]}" if product[6] else None
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
            "Quantity": product[2] if product[5] != "To Be Made" else None,
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "Status": determine_status(product[2]) if product[5] != "To Be Made" else "To Be Made"
        }
    
    raise HTTPException(status_code=404, detail="Product not found")

@InventoryRouter.post("/inventoryproduct/")
async def create_inventory_product(
    request: Request,
    ProductID: str = Form(...),  # Accept ProductID as input
    ProductName: str = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    ProcessType: str = Form(...),
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db),
):
    try:
        # Check if the ProductID already exists
        db[0].execute("SELECT id FROM inventoryproduct WHERE id = %s", (ProductID,))
        existing_product = db[0].fetchone()
        if existing_product:
            raise HTTPException(status_code=400, detail="ProductID already exists")

        image_filename = None

        if ProcessType not in ["Ready-Made", "To Be Made"]:
            raise HTTPException(status_code=400, detail="Invalid Process Type")

        if Image:
            file_extension = Image.filename.split(".")[-1]
            image_filename = f"{ProductID}_{ProductName.replace(' ', '_')}.{file_extension}"
            file_path = os.path.join(UPLOAD_DIR, image_filename)
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(Image.file, buffer)

        quantity = 0 if ProcessType == "To Be Made" else 0  # Ensure it's never NULL

        db[0].execute(
            "INSERT INTO inventoryproduct (id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, ProcessType, Image) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (ProductID, ProductName, quantity, UnitPrice, CategoryID, ProcessType, image_filename)
        )
        db[1].commit()


        log_activity(db, "pi pi-box", f"New product added: {ProductName} ({ProcessType})", "Success")

        log_product_transaction(
            db=db,
            product_id=ProductID,
            product_name=ProductName,
            transaction_type="Add",
            process_type=ProcessType,
            unit_price=UnitPrice,
            category_id=CategoryID
        )
        base_url = str(request.base_url)
        image_url = f"{base_url}uploads/products/{image_filename}" if image_filename else None

        return {
            "ProductID": ProductID,
            "ProductName": ProductName,
            "Quantity": quantity,
            "UnitPrice": UnitPrice,
            "CategoryID": CategoryID,
            "ProcessType": ProcessType,
            "Image": image_url
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@InventoryRouter.put("/inventoryproduct/{product_id}", response_model=dict)
async def update_inventory_product(
    product_id: int,
    ProductName: Optional[str] = Form(None),
    Quantity: Optional[int] = Form(None),
    UnitPrice: Optional[float] = Form(None),
    CategoryID: Optional[int] = Form(None),
    Image: Optional[UploadFile] = File(None),
    TransactionType: Optional[str] = Form(None),  # Added Transaction Type
    db=Depends(get_db),
):
    db[0].execute(
        "SELECT ProductName, Quantity, UnitPrice, Image, ProcessType FROM inventoryproduct WHERE id = %s",
        (product_id,),
    )
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    update_fields = []
    update_values = []
    image_filename = product[3]  # Image filename from DB

    if ProductName is not None:
        update_fields.append("ProductName = %s")
        update_values.append(ProductName)

    if Quantity is not None and product[4] != "To Be Made":
        update_fields.append("Quantity = %s")
        update_values.append(Quantity)
        Status = determine_status(Quantity)
        update_fields.append("Status = %s")
        update_values.append(Status)

    if UnitPrice is not None:
        update_fields.append("UnitPrice = %s")
        update_values.append(UnitPrice)

    if CategoryID is not None:
        update_fields.append("`CategoryID (FK)` = %s")
        update_values.append(CategoryID)

    if Image:
        file_extension = Image.filename.split(".")[-1]
        image_filename = f"{ProductName.replace(' ', '_')}_{int(datetime.utcnow().timestamp())}.{file_extension}"
        file_path = os.path.join(UPLOAD_DIR, image_filename)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(Image.file, buffer)

        # Remove old image if exists
        if product[3]:
            old_image_path = os.path.join(UPLOAD_DIR, product[3])
            if os.path.exists(old_image_path):
                os.remove(old_image_path)

        update_fields.append("Image = %s")
        update_values.append(image_filename)

    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    update_query = f"UPDATE inventoryproduct SET {', '.join(update_fields)} WHERE id = %s"
    update_values.append(product_id)

    db[0].execute(update_query, tuple(update_values))
    db[1].commit()

    log_activity(db, "pi pi-pencil", f"Product updated: {ProductName or product[0]}", "Updated")

    if Quantity is not None or UnitPrice is not None:
        log_product_transaction(
            db=db,
            product_id=product_id,
            product_name=ProductName or product[0],
            transaction_type="Edit",
            process_type=product[4],
            unit_price=UnitPrice or product[2],
            category_id=CategoryID
        )

    return {
        "message": "Product updated successfully",
        "Image": f"/uploads/products/{image_filename}" if image_filename else None,
    }

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