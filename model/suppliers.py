from fastapi import APIRouter, Depends, HTTPException, Form
from typing import List
from .db import get_db
from datetime import datetime

SupplierRouter = APIRouter(tags=["Suppliers"])

def log_activity(db, icon: str, title: str, status: str):
    try:
        query = "INSERT INTO activity_logs (icon, status, title, time) VALUES (%s, %s, %s, %s)"
        db[0].execute(query, (icon, status, title, datetime.now()))
        db[1].commit()
    except Exception as e:
        print(f"Error logging activity: {str(e)}")


@SupplierRouter.post("/suppliers/", response_model=dict)
async def create_supplier(
    suppliername: str = Form(..., min_length=1, max_length=255),  
    contactinfo: str = Form(..., min_length=1, max_length=20),    
    email: str = Form(...),  
    db=Depends(get_db)
):
    try:
        query = "INSERT INTO suppliers (suppliername, contactinfo, email) VALUES (%s, %s, %s)"
        db[0].execute(query, (suppliername.strip(), contactinfo.strip(), email.strip()))
        db[1].commit()
        
        db[0].execute("SELECT LAST_INSERT_ID()")
        new_supplier_id = db[0].fetchone()[0]

        log_activity(db, "pi pi-truck", f"New supplier added: {suppliername} ", "Success")

        return {"id": new_supplier_id, "suppliername": suppliername, "contactinfo": contactinfo, "email": email}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@SupplierRouter.get("/", response_model=List[dict])
async def read_suppliers(db=Depends(get_db)):
    query = "SELECT id, suppliername, contactinfo, email FROM suppliers"
    db[0].execute(query)
    suppliers = [{"id": supplier[0], "suppliername": supplier[1], "contactinfo": supplier[2], "email": supplier[3]} for supplier in db[0].fetchall()]
    return suppliers

@SupplierRouter.get("/suppliers/{supplier_id}", response_model=dict)
async def read_supplier(supplier_id: int, db=Depends(get_db)):
    query = "SELECT id, suppliername, contactinfo, email FROM suppliers WHERE id = %s"
    db[0].execute(query, (supplier_id,))
    supplier = db[0].fetchone()
    if supplier:
        return {"id": supplier[0], "suppliername": supplier[1], "contactinfo": supplier[2], "email": supplier[3]}
    raise HTTPException(status_code=404, detail="Supplier not found")

@SupplierRouter.put("/suppliers/{supplier_id}", response_model=dict)
async def update_supplier(
    supplier_id: int,
    suppliername: str = Form(...),
    contactinfo: str = Form(...),
    email: str = Form(...),
    db=Depends(get_db)
):
    query_check_supplier = "SELECT suppliername FROM suppliers WHERE id = %s"
    db[0].execute(query_check_supplier, (supplier_id,))
    supplier = db[0].fetchone()

    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")

    update_query = "UPDATE suppliers SET suppliername = %s, contactinfo = %s, email = %s WHERE id = %s"
    db[0].execute(update_query, (suppliername, contactinfo, email, supplier_id))
    db[1].commit()

    log_activity(db, "pi pi-pencil", f"Supplier updated: {suppliername}", "Updated")
    return {"message": "Supplier updated successfully"}
@SupplierRouter.delete("/suppliers/{supplier_id}", response_model=dict)
async def delete_supplier(supplier_id: int, db=Depends(get_db)):
    query_check_supplier = "SELECT suppliername FROM suppliers WHERE id = %s"
    db[0].execute(query_check_supplier, (supplier_id,))
    supplier = db[0].fetchone()

    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")

    try:

        query_delete_supplier = "DELETE FROM suppliers WHERE id = %s"
        db[0].execute(query_delete_supplier, (supplier_id,))
        db[1].commit()

        log_activity(db, "pi pi-trash", f"Supplier deleted: {supplier[0]}", "Deleted")
        return {"message": "Supplier deleted successfully"}

    except Exception as e:
        db[1].rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")



@SupplierRouter.get("/activity_logs", response_model=List[dict])
async def get_supplier_activity_logs(db=Depends(get_db)):
    query = """
    SELECT id, icon, status, title, time
    FROM activity_logs 
    WHERE title LIKE 'New supplier%' 
       OR title LIKE 'Supplier updated%' 
       OR title LIKE 'Supplier deleted%' 
    ORDER BY time DESC
    """
    db[0].execute(query)
    logs = [
        {
            "id": log[0],
            "icon": log[1],  
            "status": log[2],
            "title": log[3],
            "time": log[4]
        }
        for log in db[0].fetchall()
    ]
    return logs



