from pydantic import BaseModel,EmailStr


class UserSignUp(BaseModel):
    email:EmailStr
    password:str


class UserCurrent(BaseModel):
    email:EmailStr
    id:str