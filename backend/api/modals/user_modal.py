from sqlalchemy import Column,String,UUID,DateTime
from datetime import datetime
from uuid import uuid4
from api.depends.database import Base
class User(Base):
    __tablename__ = 'users'
    id = Column(UUID, primary_key=True, default=uuid4)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)