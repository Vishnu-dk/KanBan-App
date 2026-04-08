from pydantic import BaseModel,Field,FutureDate
from typing import Optional
from datetime import datetime

class CardCreate(BaseModel):
    title: Optional[str] = None
    due_date: Optional[FutureDate] = None
    column_id:str
    description:Optional[str] = Field(None, max_length=1000)

class CardUpdate(BaseModel):
    position: Optional[int] = None
    title: Optional[str] = None
    due_date: Optional[FutureDate] = None
    description:Optional[str] = Field(None, max_length=1000)
    column_id:Optional[str]


