import os
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

# Import routers
from model.auth import AuthRouter
from model.activity_logs import ActivityLogsRouter
from model.users import UsersRouter
from model.inventoryproduct import InventoryRouter
from model.stock import StockRouter
from model.createproduct import CreateProductRouter
from model.createorder import CreateOrderRouter
from model.ordersummary import OrderSummaryRouter
from model.sales import SalesRouter
from model.reports import ReportRouter
from model.categories import CategoryRouter
from model.suppliers import SupplierRouter

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

# Ensure the uploads directories exist
os.makedirs("uploads/profile_pics", exist_ok=True)
os.makedirs("uploads/products", exist_ok=True)  # Ensure product uploads directory exists

# Mount static files for serving profile pictures and products
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# Include CRUD routes from modules
app.include_router(AuthRouter, prefix="/Auth")
app.include_router(ActivityLogsRouter, tags=["Activity Logs"])
app.include_router(UsersRouter, prefix="/api/users", tags=["Users"])
app.include_router(InventoryRouter, prefix="/api/inventory", tags=["Inventory"])
app.include_router(StockRouter, prefix="/api/stock", tags=["Stocks"])
app.include_router(CreateProductRouter, prefix="/api/products", tags=["Products"])
app.include_router(CategoryRouter, prefix="/api/categories", tags=["Categories"])
app.include_router(SupplierRouter, prefix="/api/suppliers", tags=["Suppliers"])
app.include_router(SalesRouter, prefix="/api/sales", tags=["Sales"])
app.include_router(ReportRouter, prefix="/api/reports", tags=["Reports"])
app.include_router(CreateOrderRouter, prefix="/api/orders", tags=["Orders"])
app.include_router(OrderSummaryRouter, prefix="/api/ordersummary", tags=["Order Summary"])

