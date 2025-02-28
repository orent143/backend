from fastapi import Depends, HTTPException, APIRouter, Form
from typing import List, Optional
from pydantic import BaseModel
from model.db import get_db
from datetime import datetime

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

@InventoryRouter.get("/", response_model=list)
async def read_inventory_products(db=Depends(get_db)):
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)` FROM inventoryproduct")
    products = db[0].fetchall()

    return [
        {
            "id": product[0],
            "ProductName": product[1],
            "Quantity": product[2],
            "UnitPrice": product[3],
            "CategoryID": product[4],
            "Status": determine_status(product[2])
        }
        for product in products
    ]

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
    ProductName: str = Form(...),
    Quantity: int = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    db=Depends(get_db)
):
    try:
        Status = determine_status(Quantity)

        db[0].execute(
             "INSERT INTO inventoryproduct (ProductName, Quantity, UnitPrice, `CategoryID (FK)`, Status) VALUES (%s, %s, %s, %s, %s)",
             (ProductName, Quantity, UnitPrice, CategoryID, Status)
        )
        db[1].commit()

        db[0].execute("SELECT LAST_INSERT_ID()")
        new_product_id = db[0].fetchone()[0]

        return {
            "id": new_product_id,
            "ProductName": ProductName,
            "Quantity": Quantity,
            "UnitPrice": UnitPrice,
            "CategoryID": CategoryID,
            "Status": Status,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@InventoryRouter.put("/inventoryproduct/{product_id}", response_model=dict)
async def update_inventory_product(product_id: int, product_data: ProductUpdate, db=Depends(get_db)):
    db[0].execute("SELECT id, Quantity FROM inventoryproduct WHERE id = %s", (product_id,))
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    update_fields = []
    update_values = []

    if product_data.ProductName is not None:
        update_fields.append("ProductName = %s")
        update_values.append(product_data.ProductName)

    if product_data.Quantity is not None:
        update_fields.append("Quantity = %s")
        update_values.append(product_data.Quantity)

        Status = determine_status(product_data.Quantity)
        update_fields.append("Status = %s")
        update_values.append(Status)

    if product_data.UnitPrice is not None:
        update_fields.append("UnitPrice = %s")
        update_values.append(product_data.UnitPrice)

    if product_data.CategoryID is not None:
        update_fields.append("`CategoryID (FK)` = %s")
        update_values.append(product_data.CategoryID)

    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    update_query = f"UPDATE inventoryproduct SET {', '.join(update_fields)} WHERE id = %s"
    update_values.append(product_id)

    db[0].execute(update_query, tuple(update_values))
    db[1].commit()

    return {"message": "Product updated successfully"}

@InventoryRouter.delete("/inventoryproduct/{product_id}", response_model=dict)
async def delete_inventory_product(product_id: int, db=Depends(get_db)):
    try:
        db[0].execute("SELECT id FROM inventoryproduct WHERE id = %s", (product_id,))
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        db[0].execute("DELETE FROM inventoryproduct WHERE id = %s", (product_id,))
        db[1].commit()

        return {"message": "Product deleted successfully"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    
@InventoryRouter.post("/inventorysummary", response_model=list)
async def post_inventory_summary(db=Depends(get_db)):
    try:
        report_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Include time

        # Insert a new report entry
        db[0].execute(
            "INSERT INTO reports (ReportType, ReportName, ReportDate) VALUES (%s, %s, %s)",
            ("Daily", "Inventory Summary", report_date)
        )
        db[1].commit()

        # Fetch all inventory products
        db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)` FROM inventoryproduct")
        products = db[0].fetchall()

        # Store inventory snapshot with accurate timestamps
        for product in products:
            product_id, product_name, quantity, unit_price, category_id = product
            status = determine_status(quantity if quantity is not None else 0)

            db[0].execute(
                "INSERT INTO inventory_reports (ReportDate, ProductID, ProductName, Quantity, UnitPrice, CategoryID, Status) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (report_date, product_id, product_name, quantity, unit_price, category_id, status)
            )

        db[1].commit()

        return [
            {
                "id": product[0],
                "ProductName": product[1],
                "Quantity": product[2],
                "UnitPrice": product[3],
                "CategoryID": product[4],
                "Status": determine_status(product[2] if product[2] is not None else 0),
            }
            for product in products
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating inventory summary: {str(e)}")