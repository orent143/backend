from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from model.users import UsersRouter
from model.inventoryproduct import InventoryRouter  # Import the router for inventory products
from model.categories import CategoryRouter  # Import the router for categories
from model.suppliers import SupplierRouter  # Import the router for suppliers

# Create FastAPI app
app = FastAPI()

# CORS configuration
origins = [
    "http://localhost:5173",  # Your Vue.js development server
    # Add any other frontend origins if needed
]

# Add CORSMiddleware to allow requests from your frontend (Vue.js)
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Allow only specified origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

# Include CRUD routes from modules
app.include_router(UsersRouter, prefix="/api")
app.include_router(InventoryRouter, prefix="/api/inventory", tags=["InventoryProduct"])
app.include_router(CategoryRouter, prefix="/api/categories", tags=["Categories"])
app.include_router(SupplierRouter, prefix="/api/suppliers", tags=["Suppliers"])

