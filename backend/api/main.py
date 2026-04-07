

from fastapi import FastAPI,Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from api.routes.auth_routes import router as auth_router
from api.routes.board_routes import router as board_router
from api.routes.column_routes import router as column_router
from api.routes.card_routes import router as card_router


app=FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

@app.get("/")
def check():
    return {
        "message":"api running"
    }

app.include_router(auth_router)
app.include_router(board_router)
app.include_router(column_router)
app.include_router(card_router)


