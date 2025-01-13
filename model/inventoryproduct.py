from fastapi import Depends, HTTPException, APIRouter, Form
from typing import List, Optional
from .db import get_db

InventoryRouter = APIRouter(tags=["InventoryProduct"])

# CRUD operations for inventoryproduct

@InventoryRouter.get("/inventoryproduct/", response_model=list)
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

@InventoryRouter.post("/inventoryproduct/", response_model=dict)
async def create_inventory_product(
    ProductName: str = Form(...),
    Quantity: int = Form(...),
    UnitPrice: float = Form(...),
    CategoryID: Optional[int] = Form(None),
    SupplierID: Optional[int] = Form(None),
    Status: str = Form(...),
    db=Depends(get_db)
):
    # Fetch available categories and suppliers
    db[0].execute("SELECT id FROM categories")
    available_categories = [category[0] for category in db[0].fetchall()]

    db[0].execute("SELECT id FROM suppliers")
    available_suppliers = [supplier[0] for supplier in db[0].fetchall()]

    # Check if provided CategoryID and SupplierID are valid
    if CategoryID and CategoryID not in available_categories:
        raise HTTPException(status_code=400, detail="Invalid CategoryID")
    if SupplierID and SupplierID not in available_suppliers:
        raise HTTPException(status_code=400, detail="Invalid SupplierID")

    # Insert the new product into the inventoryproduct table
    query = """
    INSERT INTO inventoryproduct (ProductName, Quantity, UnitPrice, `CategoryID (FK)`, `SupplierID (FK)`, Status) 
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    db[0].execute(query, (ProductName, Quantity, UnitPrice, CategoryID, SupplierID, Status))
    
    # Retrieve the last inserted ID using LAST_INSERT_ID()
    db[0].execute("SELECT LAST_INSERT_ID()")
    new_product_id = db[0].fetchone()[0]
    db[1].commit()  # Ensure changes are committed
    
    # Return a response with the product ID and name
    return {"id": new_product_id, "ProductName": ProductName}


@InventoryRouter.put("/inventoryproduct/{product_id}", response_model=dict)
async def update_inventory_product(
    product_id: int,
    ProductName: Optional[str] = Form(None),
    Quantity: Optional[int] = Form(None),
    UnitPrice: Optional[float] = Form(None),
    CategoryID: Optional[int] = Form(None),
    SupplierID: Optional[int] = Form(None),
    Status: Optional[str] = Form(None),
    db=Depends(get_db)
):
    # Check if the product exists
    query_check_product = "SELECT id FROM inventoryproduct WHERE id = %s"
    db[0].execute(query_check_product, (product_id,))
    product = db[0].fetchone()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Construct the update query dynamically based on provided fields
    update_query = """
    UPDATE inventoryproduct 
    SET ProductName = COALESCE(%s, ProductName), 
        Quantity = COALESCE(%s, Quantity), 
        UnitPrice = COALESCE(%s, UnitPrice), 
        `CategoryID (FK)` = COALESCE(%s, `CategoryID (FK)`), 
        `SupplierID (FK)` = COALESCE(%s, `SupplierID (FK)`), 
        Status = COALESCE(%s, Status) 
    WHERE id = %s
    """
    db[0].execute(update_query, (
        ProductName, Quantity, UnitPrice, CategoryID, SupplierID, Status, product_id
    ))
    
    db[1].commit()  # Ensure changes are committed

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

        return {"message": "Product deleted successfully"}
    except Exception as e:
        # Handle other exceptions if necessary
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    finally:
        # Close the database cursor if needed
        db[0].close()
