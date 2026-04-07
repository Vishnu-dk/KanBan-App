from pydantic import BaseModel
from typing import Optional
 
class ColumnCreate(BaseModel):
    name:str
    board_id:str

class ColumnUpdate(BaseModel):
    name:str|None=None
    position:Optional[int]=None