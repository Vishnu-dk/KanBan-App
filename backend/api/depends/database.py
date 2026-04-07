from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from dotenv import load_dotenv
from sqlalchemy.engine import URL
import os
import time


load_dotenv()

DATABASE_URL=URL.create(
    "postgresql+psycopg2",
    username=os.getenv("POSTGRES_USER","postgres"),
    password=os.getenv("POSTGRES_PASSWORD","Kripa@123"),
    database=os.getenv("POSTGRES_DB","todo_db"),
    host=os.getenv("POSTGRES_HOST","db"),
    port=int(os.getenv("POSTGRES_PORT","5432")),
)

Base= declarative_base()
engine=create_engine(DATABASE_URL,pool_pre_ping=True,  pool_size=5,max_overflow=10 )

SessionLocal=sessionmaker(autoflush=False,autocommit=False,bind=engine)


def get_db():
    db=SessionLocal()
    try:
        yield db
    finally:
        db.close()