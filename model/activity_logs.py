from fastapi import APIRouter, Depends
from model.db import get_db

ActivityLogsRouter = APIRouter(tags=["Activity Logs"])

@ActivityLogsRouter.get("/api/activity_logs", tags=["Activity Logs"])
async def get_activity_logs(db=Depends(get_db)):
    db[0].execute("SELECT id, icon, title, time, status FROM activity_logs ORDER BY time DESC LIMIT 10")
    logs = db[0].fetchall()

    return [
        {
            "id": log[0],
            "icon": log[1],
            "title": log[2],
            "time": log[3].strftime("%Y-%m-%d %H:%M:%S"),
            "status": log[4]
        }
        for log in logs
    ]
