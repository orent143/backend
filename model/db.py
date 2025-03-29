# model/db.py
import mysql.connector

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "web2_demo1",
    "port": 3306,
}

def get_db():
    db = mysql.connector.connect(**db_config)
    
    # Use buffered=True to prevent unread results error
    cursor = db.cursor(buffered=True)  
    
    try:
        yield cursor, db
    finally:
        if cursor:
            cursor.close()
        if db.is_connected():
            db.close()
