from sqlalchemy import Column,String,UUID,DateTime,ForeignKey,Integer,Text,Date
from sqlalchemy.orm import relationship
from datetime import datetime
from uuid import uuid4
from api.depends.database import Base


class Card(Base):
    __tablename__ = 'cards'
    id = Column(UUID, primary_key=True, default=uuid4)
    title = Column(String, nullable=False)
    description = Column(Text)
    column_id = Column(UUID, ForeignKey('columns.id',ondelete="CASCADE"), nullable=False)
    position = Column(Integer)
    due_date = Column(Date, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    column = relationship("Column",back_populates="cards")