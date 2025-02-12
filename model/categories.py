# categories.py (CRUD for categories)
from fastapi import APIRouter, Depends, HTTPException, Form
from typing import List
from .db import get_db

CategoryRouter = APIRouter(tags=["Categories"])


# Create a category
@CategoryRouter.post("/categories/", response_model=dict)
async def create_category(
    CategoryName: str = Form(...),
    db=Depends(get_db)
):
    query = "INSERT INTO categories (CategoryName) VALUES (%s)"
    db[0].execute(query, (CategoryName,))
    db[1].commit()  # Ensure changes are committed
    
    db[0].execute("SELECT LAST_INSERT_ID()")
    new_category_id = db[0].fetchone()[0]
    return {"id": new_category_id, "CategoryName": CategoryName}

# FastAPI router includes `/api/categories`
@CategoryRouter.get("/", response_model=List[dict])
async def read_categories(db=Depends(get_db)):
    query = "SELECT id, CategoryName FROM categories"
    db[0].execute(query)
    categories = [{"id": category[0], "CategoryName": category[1]} for category in db[0].fetchall()]
    return categories



# Read a specific category
@CategoryRouter.get("/categories/{category_id}", response_model=dict)
async def read_category(category_id: int, db=Depends(get_db)):
    query = "SELECT id, CategoryName FROM categories WHERE id = %s"
    db[0].execute(query, (category_id,))
    category = db[0].fetchone()
    if category:
        return {"id": category[0], "CategoryName": category[1]}
    raise HTTPException(status_code=404, detail="Category not found")

# Update a category
@CategoryRouter.put("/categories/{category_id}", response_model=dict)
async def update_category(category_id: int, CategoryName: str = Form(...), db=Depends(get_db)):
    print(f"Updating category with ID: {category_id}")  # Debugging line

    query_check_category = "SELECT id FROM categories WHERE id = %s"
    db[0].execute(query_check_category, (category_id,))
    category = db[0].fetchone()

    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    update_query = "UPDATE categories SET CategoryName = %s WHERE id = %s"
    db[0].execute(update_query, (CategoryName, category_id))
    db[1].commit()
    return {"message": "Category updated successfully"}

# Delete a category
@CategoryRouter.delete("/categories/{category_id}", response_model=dict)
async def delete_category(category_id: int, db=Depends(get_db)):
    print(f"Received DELETE request for category ID: {category_id}")  # Debugging log
    
    query_check_category = "SELECT id FROM categories WHERE id = %s"
    db[0].execute(query_check_category, (category_id,))
    category = db[0].fetchone()

    if not category:
        print(f"Category ID {category_id} not found")  # Debugging log
        raise HTTPException(status_code=404, detail="Category not found")

    query_delete_category = "DELETE FROM categories WHERE id = %s"
    db[0].execute(query_delete_category, (category_id,))
    db[1].commit()

    print(f"Category ID {category_id} deleted successfully")  # Debugging log
    return {"message": "Category deleted successfully"}

