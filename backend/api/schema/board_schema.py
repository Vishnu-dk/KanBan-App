from pydantic import BaseModel

class BoardCreate(BaseModel):
    name:str

class BoardDelete(BaseModel):
    id:int
