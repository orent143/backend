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

# Function to get inventory summary
def get_inventory_summary(db):
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice FROM inventoryproduct")
    products = db[0].fetchall()

    low_stock_items = []
    out_of_stock_items = []
    total_value = 0

    for product in products:
        status = determine_status(product[2])

        if status == "Out of Stock":
            out_of_stock_items.append(product)
        elif status == "Low Stock":
            low_stock_items.append(product)

        total_value += product[2] * product[3]

    return {
        "date": datetime.now().strftime("%Y-%m-%d"),
        "total_items": len(products),
        "total_value": total_value,
        "low_stock_count": len(low_stock_items),
        "out_of_stock_count": len(out_of_stock_items)
    }

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

        summary = get_inventory_summary(db)

        return {"message": "Product deleted successfully", "inventory_summary": summary}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    
    finally:
        db[0].close()

# New endpoint to fetch inventory products for menu items
@InventoryRouter.get("/menuitems", response_model=list)
async def fetch_menu_items(db=Depends(get_db)):
    try:
        db[0].execute("SELECT id, ProductName, UnitPrice FROM inventoryproduct WHERE Quantity > 0")
        products = db[0].fetchall()

        return [
            {
                "id": product[0],
                "name": product[1],
                "price": float(product[2])  # Ensure price is returned as a float
            }
            for product in products
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching menu items: {str(e)}")
