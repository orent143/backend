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
    SupplierID: Optional[int] = None
    Status: Optional[str] = None
# CRUD operations for inventoryproduct

# Function to get inventory summary
def get_inventory_summary(db):
    low_stock_items = []
    out_of_stock_items = []
    total_value = 0

    # Fetch all products
    db[0].execute("SELECT id, ProductName, Quantity, UnitPrice, Status FROM inventoryproduct")
    products = db[0].fetchall()

    # Categorize products based on stock level
    for product in products:
        if product[2] == 0:
            out_of_stock_items.append(product)
        elif product[2] <= 10:
            low_stock_items.append(product)
        
        total_value += product[2] * product[3]  # Quantity * UnitPrice

    # Summary
    summary = {
        "date": datetime.now().strftime("%Y-%m-%d"),
        "total_items": len(products),
        "total_value": total_value,
        "low_stock_count": len(low_stock_items),
        "out_of_stock_count": len(out_of_stock_items)
    }

    return summary


@InventoryRouter.get("/", response_model=list)
async def read_inventory_products(
    db=Depends(get_db)
):
    query = "SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Status FROM inventoryproduct"
    db[0].execute(query)
    products = [{"id": product[0], "ProductName": product[1], "Quantity": product[2], "UnitPrice": product[3],
                 "CategoryID": product[4], "SupplierID": product[5], "Status": product[6]} for product in db[0].fetchall()]
    return products


@InventoryRouter.get("/inventoryproduct/{product_id}", response_model=dict)
async def read_inventory_product(
    product_id: int, 
    db=Depends(get_db)
):
    query = "SELECT id, ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Status FROM inventoryproduct WHERE id = %s"
    db[0].execute(query, (product_id,))
    product = db[0].fetchone()
    if product:
        return {"id": product[0], "ProductName": product[1], "Quantity": product[2], "UnitPrice": product[3],
                "CategoryID": product[4], "SupplierID": product[5], "Status": product[6]}
    raise HTTPException(status_code=404, detail="Product not found")


@InventoryRouter.post("/inventoryproduct/")
async def create_inventory_product(
    ProductName: str = Form(...),
    Quantity: int = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    SupplierID: Optional[int] = Form(None),
    Status: str = Form(...),
    db=Depends(get_db)
):
    try:
        db[0].execute(
            "INSERT INTO inventoryproduct (ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Status) VALUES (%s, %s, %s, %s, %s, %s)",
            (ProductName, Quantity, UnitPrice, CategoryID, SupplierID, Status)
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
            "SupplierID": SupplierID,
            "Status": Status,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@InventoryRouter.put("/inventoryproduct/{product_id}", response_model=dict)
async def update_inventory_product(
    product_id: int,
    product_data: ProductUpdate,
    db=Depends(get_db)
):
    # Check if the product exists
    query_check_product = "SELECT id FROM inventoryproduct WHERE id = %s"
    db[0].execute(query_check_product, (product_id,))
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Build dynamic update query
    update_fields = []
    update_values = []

    if product_data.ProductName is not None:
        update_fields.append("ProductName = %s")
        update_values.append(product_data.ProductName)

    if product_data.Quantity is not None:
        update_fields.append("Quantity = %s")
        update_values.append(product_data.Quantity)

    if product_data.UnitPrice is not None:
        update_fields.append("UnitPrice = %s")
        update_values.append(product_data.UnitPrice)

    if product_data.CategoryID is not None:
        update_fields.append("`CategoryID (FK)` = %s")
        update_values.append(product_data.CategoryID)

    if product_data.SupplierID is not None:
        update_fields.append("`SupplierID (FK)` = %s")
        update_values.append(product_data.SupplierID)

    if product_data.Status is not None:
        update_fields.append("Status = %s")
        update_values.append(product_data.Status)

    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    update_query = f"UPDATE inventoryproduct SET {', '.join(update_fields)} WHERE id = %s"
    update_values.append(product_id)

    db[0].execute(update_query, tuple(update_values))
    db[1].commit()

    return {"message": "Product updated successfully"}



@InventoryRouter.delete("/inventoryproduct/{product_id}", response_model=dict)
async def delete_inventory_product(
    product_id: int,
    db=Depends(get_db)
):
    try:
        # Check if the product exists
        query_check_product = "SELECT id FROM inventoryproduct WHERE id = %s"
        db[0].execute(query_check_product, (product_id,))
        product = db[0].fetchone()

        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # Delete the product
        query_delete_product = "DELETE FROM inventoryproduct WHERE id = %s"
        db[0].execute(query_delete_product, (product_id,))
        db[1].commit()  # Ensure changes are committed

        # Create inventory summary after deleting a product
        summary = get_inventory_summary(db)

        return {"message": "Product deleted successfully", "inventory_summary": summary}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    finally:
        db[0].close()
