from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File
from .db import get_db
import bcrypt
import shutil
import os
from datetime import datetime
from fastapi import Request

UPLOAD_DIR = "uploads/profile_pics"
os.makedirs(UPLOAD_DIR, exist_ok=True)

UsersRouter = APIRouter(tags=["Users"])

ALLOWED_ROLES = {"admin", "cafe_staff"}

@UsersRouter.get("/", response_model=list)
async def read_users(request: Request, db=Depends(get_db)):
    base_url = str(request.base_url)
    query = "SELECT id, username, role, profile_pic, date_added FROM users"
    db[0].execute(query)
    users = [
        {
            "id": user[0],
            "username": user[1],
            "role": user[2],
            "profile_pic": f"{base_url}uploads/{user[3]}" if user[3] else None,
            "date_added": user[4]
        }
        for user in db[0].fetchall()
    ]
    return users

@UsersRouter.get("/users/{user_id}", response_model=dict)
async def read_user(user_id: int, request: Request, db=Depends(get_db)):
    base_url = str(request.base_url).rstrip("/")  
    query = "SELECT id, username, role, profile_pic, date_added FROM users WHERE id = %s"
    db[0].execute(query, (user_id,))
    user = db[0].fetchone()
    
    if user:
        return {
            "id": user[0],
            "username": user[1],
            "role": user[2],
            "profile_pic": f"{base_url}/uploads/profile_pics/{user[3]}" if user[3] else None,
            "date_added": user[4]
        }
    
    raise HTTPException(status_code=404, detail="User not found")


@UsersRouter.post("/users/", response_model=dict)
async def create_user(
    username: str = Form(...),
    password: str = Form(...),
    role: str = Form(...),
    profile_pic: UploadFile = File(None),
    db=Depends(get_db)
):
    if role not in ALLOWED_ROLES:
        raise HTTPException(status_code=400, detail="Invalid role. Allowed roles: 'admin', 'cafe_staff'.")

    cursor, conn = db
    hashed_password = hash_password(password)
    date_added = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    file_name = None
    if profile_pic:
        file_extension = profile_pic.filename.split(".")[-1]
        file_name = f"{username}_{int(datetime.utcnow().timestamp())}.{file_extension}"
        file_path = os.path.join(UPLOAD_DIR, file_name)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(profile_pic.file, buffer)

    query = "INSERT INTO users (username, password, role, profile_pic, date_added) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (username, hashed_password, role, file_name, date_added))

    cursor.execute("SELECT LAST_INSERT_ID()")
    new_user_id = cursor.fetchone()[0]
    conn.commit()
    cursor.close()

    return {
        "id": new_user_id,
        "username": username,
        "role": role,
        "profile_pic": file_name,
        "date_added": date_added
    }

@UsersRouter.delete("/users/{user_id}", response_model=dict)
async def delete_user(user_id: int, db=Depends(get_db)):
    try:
        query_check_user = "SELECT id FROM users WHERE id = %s"
        db[0].execute(query_check_user, (user_id,))
        existing_user = db[0].fetchone()

        if not existing_user:
            raise HTTPException(status_code=404, detail="User not found")

        query_delete_user = "DELETE FROM users WHERE id = %s"
        db[0].execute(query_delete_user, (user_id,))
        db[1].commit()

        return {"message": "User deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    finally:
        db[0].close()

# Password hashing function using bcrypt
def hash_password(password: str):
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed_password.decode('utf-8')
