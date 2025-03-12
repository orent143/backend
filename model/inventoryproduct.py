from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File, Request
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
import os
import shutil
from datetime import datetime

UPLOAD_DIR = "uploads/products"
os.makedirs(UPLOAD_DIR, exist_ok=True)

InventoryRouter = APIRouter(tags=["InventoryProduct"])

class ProductUpdate(BaseModel):
    ProductName: Optional[str] = None
    Quantity: Optional[int] = None
    UnitPrice: Optional[float] = None
    CategoryID: Optional[int] = None

# Function to determine stock status
def determine_status(quantity: int) -> str:
    if quantity == 0:
        return "Out of Stock"
    elif quantity <= 10:
        return "Low Stock"
    else:
        return "In Stock"

# Function to log activity
def log_activity(db, icon: str, title: str, status: str):
    try:
        db[0].execute(
            "INSERT INTO activity_logs (icon, title, time, status) VALUES (%s, %s, NOW(), %s)",
            (icon, title, status),
        )
        db[1].commit()
    except Exception as e:
        print(f"Failed to log activity: {e}")



@InventoryRouter.get("/", response_model=list)
async def read_inventory_products(request: Request, db=Depends(get_db)):
    base_url = str(request.base_url)
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Image FROM inventoryproduct")
    products = db[0].fetchall()

    return [
        {
            "id": product[0],
            "ProductName": product[1],
            "Quantity": product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "SupplierID": product[5],
            "Status": determine_status(product[2]),
            "Image": f"{base_url}uploads/products/{product[6]}" if product[6] else None
        }
        for product in products
    ]



@InventoryRouter.get("/inventoryproduct/total", response_model=dict)
async def get_total_products(db=Depends(get_db)):
    try:
        db[0].execute("SELECT COUNT(*) FROM inventoryproduct")
        total_products = db[0].fetchone()[0]

        return {"total_products": total_products}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching total products: {str(e)}")

@InventoryRouter.get("/inventoryproduct/{product_id}", response_model=dict)
async def read_inventory_product(product_id: int, db=Depends(get_db)):
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)` FROM inventoryproduct WHERE id = %s", (product_id,))
    product = db[0].fetchone()

    if product:
        return {
            "id": product[0],
            "ProductName": product[1],
            "Quantity": product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "Status": determine_status(product[2])
        }
    
    raise HTTPException(status_code=404, detail="Product not found")

@InventoryRouter.post("/inventoryproduct/")
async def create_inventory_product(
    request: Request,
    ProductName: str = Form(...),
    Quantity: int = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    SupplierID: Optional[int] = Form(None),
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db),
):
    try:
        Status = determine_status(Quantity)
        image_filename = None

        # Save uploaded image
        if Image:
            file_extension = Image.filename.split(".")[-1]
            image_filename = f"{ProductName.replace(' ', '_')}_{int(datetime.utcnow().timestamp())}.{file_extension}"
            file_path = os.path.join(UPLOAD_DIR, image_filename)
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(Image.file, buffer)

        # Insert product into the database
        db[0].execute(
            "INSERT INTO inventoryproduct (ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Status, Image) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (ProductName, Quantity, UnitPrice, CategoryID, SupplierID, Status, image_filename)
        )
        db[1].commit()

        db[0].execute("SELECT LAST_INSERT_ID()")
        new_product_id = db[0].fetchone()[0]

        log_activity(db, "pi pi-box", f"New product added: {ProductName}", "Success")

        base_url = str(request.base_url)
        image_url = f"{base_url}uploads/products/{image_filename}" if image_filename else None

        return {
            "id": new_product_id,
            "ProductName": ProductName,
            "Quantity": Quantity,
            "UnitPrice": UnitPrice,
            "CategoryID": CategoryID,
            "SupplierID": SupplierID,
            "Status": Status,
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
    db=Depends(get_db),
):
    db[0].execute("SELECT ProductName, Image FROM inventoryproduct WHERE id = %s", (product_id,))
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    update_fields = []
    update_values = []
    image_filename = product[1]  # Keep existing image filename

    if ProductName is not None:
        update_fields.append("ProductName = %s")
        update_values.append(ProductName)

    if Quantity is not None:
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
    
    # Handle image upload
    if Image:
        file_extension = Image.filename.split(".")[-1]
        image_filename = f"{ProductName.replace(' ', '_')}_{int(datetime.utcnow().timestamp())}.{file_extension}"
        file_path = os.path.join(UPLOAD_DIR, image_filename)
        
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(Image.file, buffer)
        
        # Delete old image if exists
        if product[1]:
            old_image_path = os.path.join(UPLOAD_DIR, product[1])
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

    log_activity(db, "pi pi-pencil", f"Product updated: {ProductName or product[0]}", "Success")

    return {"message": "Product updated successfully", "Image": f"/uploads/products/{image_filename}" if image_filename else None}

@InventoryRouter.delete("/inventoryproduct/{product_id}", response_model=dict)
async def delete_inventory_product(product_id: int, db=Depends(get_db)):
    try:
        db[0].execute("SELECT ProductName FROM inventoryproduct WHERE id = %s", (product_id,))
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        db[0].execute("DELETE FROM inventoryproduct WHERE id = %s", (product_id,))
        db[1].commit()

        log_activity(db, "pi pi-trash", f"Product deleted: {product[0]}", "Warning")

        return {"message": "Product deleted successfully"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

    
@InventoryRouter.post("/inventorysummary", response_model=list)
async def post_inventory_summary(db=Depends(get_db)):
    try:
        report_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Include time

        # Insert into reports and get the ReportID
        db[0].execute(
            "INSERT INTO reports (ReportType, ReportName, ReportDate) VALUES (%s, %s, %s)",
            ("Daily", "Inventory Summary", report_date)
        )
        db[1].commit()

        db[0].execute("SELECT LAST_INSERT_ID()")
        report_id = db[0].fetchone()[0]  # Fetch the last inserted report ID

        # Fetch all products from inventory
        db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, Image FROM inventoryproduct")
        products = db[0].fetchall()

        # Insert inventory report entries
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