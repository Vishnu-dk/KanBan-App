from sqlalchemy import Column,String,UUID,Integer,ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from uuid import uuid4
from api.depends.database import Base

class Column(Base):
    __tablename__ = 'columns'
    id = Column(UUID, primary_key=True, default=uuid4)
    title = Column(String, nullable=False)
    board_id = Column(UUID, ForeignKey('boards.id'), nullable=False)
    position = Column(Integer) # for ordering

    board = relationship("Board",back_populates="columns")
    cards = relationship("Card", back_populates="column", cascade="all, delete-orphan")
    