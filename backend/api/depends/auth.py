
from passlib.context import CryptContext
from datetime import datetime,timedelta,timezone
from jose import jwt,JWTError
from dotenv import load_dotenv
import os
from sqlalchemy.orm import Session
from .database import get_db
from fastapi.security import OAuth2PasswordBearer
from fastapi import Depends,HTTPException
load_dotenv()
from api.modals.user_modal import User


auth_scheme=OAuth2PasswordBearer("auth/login")

ALGORITHM=os.getenv("ALGORITHM")
SECRET_KEY=os.getenv("SECRET_KEY")

pwd_context=CryptContext(
    schemes=["argon2","bcrypt","bcrypt_sha256"],
    deprecated="auto"
)

def hashing_password(password:str)->str:
    return pwd_context.hash(password)

def verify_password(password,hashed_password)->str:
    return pwd_context.verify(password,hashed_password)


DUMMY_PASS=hashing_password("DUMMY_PASSWORD")


def create_token(email)->str:
    payload={"email":email}
    expire=datetime.now(timezone.utc)+timedelta(days=15)
    payload.update({"exp":expire})
    return jwt.encode(payload,SECRET_KEY,algorithm=ALGORITHM)


def get_user(token:str=Depends(auth_scheme),db:Session=Depends(get_db)):
    try:
        payload=jwt.decode(token,SECRET_KEY,algorithms=ALGORITHM)
        email=payload["email"]
        if not email:
            raise HTTPException(status_code=401,detail="INVALID TOCKEN")
        
        current_user=db.query(User).filter(User.email==email).first()
        return current_user
    except HTTPException:
        raise
    except JWTError:
        raise HTTPException(status_code=401,detail="INVALID TOCKEN")
