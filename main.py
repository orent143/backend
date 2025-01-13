
# main.py (Updated to include routers for categories and suppliers)
from fastapi import FastAPI
from model.users import UsersRouter
from model.inventoryproduct import InventoryRouter  # Import the router for inventory products
from model.categories import CategoryRouter  # Import the router for categories
from model.suppliers import SupplierRouter  # Import the router for suppliers

app = FastAPI()

# Include CRUD routes from modules
app.include_router(UsersRouter, prefix="/api")
app.include_router(InventoryRouter, prefix="/api/inventory", tags=["InventoryProduct"])
app.include_router(CategoryRouter, prefix="/api/categories", tags=["Categories"])
app.include_router(SupplierRouter, prefix="/api/suppliers", tags=["Suppliers"])