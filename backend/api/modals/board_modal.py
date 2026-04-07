from sqlalchemy import Column,String,UUID,DateTime,ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from uuid import uuid4
from api.depends.database import Base

class Board(Base):
    __tablename__ = 'boards'
    id = Column(UUID, primary_key=True, default=uuid4)
    name = Column(String, nullable=False)
    owner_id = Column(UUID, ForeignKey('users.id'), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User")
    columns = relationship("Column", back_populates="board", cascade="all, delete-orphan")