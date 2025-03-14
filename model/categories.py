# categories.py (CRUD for categories)
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from typing import List, Optional
from .db import get_db
import os
import shutil

CategoryRouter = APIRouter(tags=["Categories"])

UPLOAD_DIR = "uploads/categories"
os.makedirs(UPLOAD_DIR, exist_ok=True)  

@CategoryRouter.post("/categories/", response_model=dict)
async def create_category(
    CategoryName: str = Form(...),
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db)
):
    image_path = None

    if Image:
        image_filename = f"{CategoryName.replace(' ', '_')}_{Image.filename}"
        image_path = f"{UPLOAD_DIR}/{image_filename}"
        
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(Image.file, buffer)

    query = "INSERT INTO categories (CategoryName, ImagePath) VALUES (%s, %s)"
    db[0].execute(query, (CategoryName, image_path))
    db[1].commit()

    db[0].execute("SELECT LAST_INSERT_ID()")
    new_category_id = db[0].fetchone()[0]

    return {"id": new_category_id, "CategoryName": CategoryName, "ImagePath": image_path}


@CategoryRouter.get("/", response_model=List[dict])
async def read_categories(db=Depends(get_db)):
    query = "SELECT id, CategoryName, ImagePath FROM categories"
    db[0].execute(query)
    categories = [
        {
            "id": cat[0],
            "CategoryName": cat[1],
            "ImagePath": f"/{cat[2]}" if cat[2] else None  
        } 
        for cat in db[0].fetchall()
    ]
    return categories


@CategoryRouter.get("/categories/{category_id}", response_model=dict)
async def read_category(category_id: int, db=Depends(get_db)):
    query = "SELECT id, CategoryName, ImagePath FROM categories WHERE id = %s"
    db[0].execute(query, (category_id,))
    category = db[0].fetchone()

    if category:
        return {"id": category[0], "CategoryName": category[1], "ImagePath": category[2]}
    
    raise HTTPException(status_code=404, detail="Category not found")


@CategoryRouter.put("/categories/{category_id}", response_model=dict)
async def update_category(
    category_id: int,
    CategoryName: str = Form(...),
    Image: Optional[UploadFile] = File(None),
    db=Depends(get_db)
):
    query_check_category = "SELECT id FROM categories WHERE id = %s"
    db[0].execute(query_check_category, (category_id,))
    category = db[0].fetchone()

    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    image_path = None
    if Image:
        image_filename = f"{CategoryName.replace(' ', '_')}_{Image.filename}"
        image_path = f"{UPLOAD_DIR}/{image_filename}"
        
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(Image.file, buffer)

        update_query = "UPDATE categories SET CategoryName = %s, ImagePath = %s WHERE id = %s"
        db[0].execute(update_query, (CategoryName, image_path, category_id))
    else:
        update_query = "UPDATE categories SET CategoryName = %s WHERE id = %s"
        db[0].execute(update_query, (CategoryName, category_id))

    db[1].commit()
    return {"message": "Category updated successfully"}


@CategoryRouter.delete("/categories/{category_id}", response_model=dict)
async def delete_category(category_id: int, db=Depends(get_db)):
    query_check_category = "SELECT ImagePath FROM categories WHERE id = %s"
    db[0].execute(query_check_category, (category_id,))
    category = db[0].fetchone()

    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    if category[0]:  
        try:
            os.remove(category[0])
        except FileNotFoundError:
            pass  

    query_delete_category = "DELETE FROM categories WHERE id = %s"
    db[0].execute(query_delete_category, (category_id,))
    db[1].commit()

    return {"message": "Category deleted successfully"}

