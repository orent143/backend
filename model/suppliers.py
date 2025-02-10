
# suppliers.py (CRUD for suppliers)
from fastapi import APIRouter, Depends, HTTPException, Form
from typing import List
from .db import get_db

SupplierRouter = APIRouter(tags=["Suppliers"])

# Create a supplier
@SupplierRouter.post("/suppliers/", response_model=dict)
async def create_supplier(
    suppliername: str = Form(...),
    contactinfo: str = Form(...),
    email: str = Form(...),
    db=Depends(get_db)
):
    query = "INSERT INTO suppliers (suppliername, contactinfo, email) VALUES (%s, %s, %s)"
    db[0].execute(query, (suppliername, contactinfo, email))
    db[1].commit()  # Ensure changes are committed
    
    db[0].execute("SELECT LAST_INSERT_ID()")
    new_supplier_id = db[0].fetchone()[0]
    return {"id": new_supplier_id, "suppliername": suppliername}

# Read all suppliers
@SupplierRouter.get("/", response_model=List[dict])
async def read_suppliers(db=Depends(get_db)):
    query = "SELECT id, suppliername, contactinfo, email FROM suppliers"
    db[0].execute(query)
    suppliers = [{"id": supplier[0], "suppliername": supplier[1], "contactinfo": supplier[2], "email": supplier[3]} for supplier in db[0].fetchall()]
    return suppliers

# Read a specific supplier
@SupplierRouter.get("/suppliers/{supplier_id}", response_model=dict)
async def read_supplier(supplier_id: int, db=Depends(get_db)):
    query = "SELECT id, suppliername, contactinfo, email FROM suppliers WHERE id = %s"
    db[0].execute(query, (supplier_id,))
    supplier = db[0].fetchone()
    if supplier:
        return {"id": supplier[0], "suppliername": supplier[1], "contactinfo": supplier[2], "email": supplier[3]}
    raise HTTPException(status_code=404, detail="Supplier not found")

# Update a supplier
@SupplierRouter.put("/suppliers/{supplier_id}", response_model=dict)
async def update_supplier(
    supplier_id: int,
    suppliername: str = Form(...),
    contactinfo: str = Form(...),
    email: str = Form(...),
    db=Depends(get_db)
):
    query_check_supplier = "SELECT id FROM suppliers WHERE id = %s"
    db[0].execute(query_check_supplier, (supplier_id,))
    supplier = db[0].fetchone()

    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")

    update_query = "UPDATE suppliers SET suppliername = %s, contactinfo = %s, email = %s WHERE id = %s"
    db[0].execute(update_query, (suppliername, contactinfo, email, supplier_id))
    db[1].commit()
    return {"message": "Supplier updated successfully"}

# Delete a supplier
@SupplierRouter.delete("/suppliers/{supplier_id}", response_model=dict)
async def delete_supplier(supplier_id: int, db=Depends(get_db)):
    query_check_supplier = "SELECT id FROM suppliers WHERE id = %s"
    db[0].execute(query_check_supplier, (supplier_id,))
    supplier = db[0].fetchone()

    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")

    query_delete_supplier = "DELETE FROM suppliers WHERE id = %s"
    db[0].execute(query_delete_supplier, (supplier_id,))
    db[1].commit()
    return {"message": "Supplier deleted successfully"}