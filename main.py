from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from model.users import UsersRouter
from model.inventoryproduct import InventoryRouter  # Import the router for inventory products
from model.stock import StockRouter  # Import the router for inventory products
from model.createproduct import CreateProductRouter  # Import the router for products
from model.createorder import CreateOrderRouter
from model.ordersummary import OrderSummaryRouter
from model.sales import SalesRouter
from model.categories import CategoryRouter  # Import the router for categories
from model.suppliers import SupplierRouter  # Import the router for suppliers

# Create FastAPI app
app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Frontend URL
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],
)

# Include CRUD routes from modules
app.include_router(UsersRouter, prefix="/api")
app.include_router(InventoryRouter, prefix="/api/inventory", tags=["InventoryProduct"])
app.include_router(StockRouter, prefix="/api/stock", tags=["Stocks"])
app.include_router(CreateProductRouter, prefix="/api/createproduct", tags=["CreateProduct"])
app.include_router(CategoryRouter, prefix="/api/categories")
app.include_router(SupplierRouter, prefix="/api/suppliers", tags=["Suppliers"])
app.include_router(SalesRouter, prefix="/api/sales", tags=["Sales"])
app.include_router(CreateOrderRouter, prefix="/api/createorder", tags=["CreateOrders"])
app.include_router(OrderSummaryRouter, prefix="/api/ordersummary", tags=["OrdersSummary"])




