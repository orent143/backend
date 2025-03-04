from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
import bcrypt
from .db import get_db  # Import database dependency

AuthRouter = APIRouter(tags=["Auth"])

# Pydantic Models
class LoginRequest(BaseModel):
    username: str
    password: str

class LoginResponse(BaseModel):
    user_id: int
    username: str  # Changed from 'name' to 'username'
    role: str

@AuthRouter.post("/login/", response_model=LoginResponse)
async def login_user(login_data: LoginRequest, db_dep=Depends(get_db)):
    cursor, conn = db_dep  

    query = "SELECT id, username, password, role FROM users WHERE username = %s"
    cursor.execute(query, (login_data.username,))
    user = cursor.fetchone()
    
    cursor.close()  

    if not user:
        raise HTTPException(status_code=401, detail="Invalid username or password")

    stored_password = user[2]

    if not bcrypt.checkpw(login_data.password.encode('utf-8'), stored_password.encode('utf-8')):
        raise HTTPException(status_code=401, detail="Invalid username or password")

    return {
        "user_id": user[0],
        "username": user[1],  # Corrected field name
        "role": user[3]
    }
