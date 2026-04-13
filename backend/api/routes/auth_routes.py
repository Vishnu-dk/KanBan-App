
from api.depends.database import get_db
from sqlalchemy.orm import Session
from fastapi import Depends,HTTPException
from api.schema.user_schema import UserSignUp
from api.modals.user_modal import User
from api.depends.auth import verify_password,hashing_password,DUMMY_PASS,create_token


from fastapi import APIRouter

router=APIRouter()

@router.post("/auth/register")
def user_register(current_user:UserSignUp, db:Session=Depends(get_db)):
    
    try:
        existing_user=db.query(User).filter(User.email==current_user.email).first()
        if existing_user:
            return "User Already Exists"
        
        hashed_pass=hashing_password(current_user.password)
    
        data=User(email=current_user.email,password_hash=hashed_pass)
        db.add(data)
        db.commit()
        db.refresh(data)
        return "User Created"
    except HTTPException:
        raise
    except:
        db.rollback()
        return "Server Error !"
    

@router.post("/auth/login")
def user_register(current_user:UserSignUp, db:Session=Depends(get_db)):
    
    try:
        existing_user=db.query(User).filter(User.email==current_user.email).first()
        if not existing_user:
            password_check=verify_password(current_user.password,DUMMY_PASS)
            raise HTTPException(status_code=402,detail="Invalid Credentials")
    
        password_check=verify_password(current_user.password,existing_user.password_hash)
        if not password_check:
            raise HTTPException(status_code=402,detail="Invalid Credentials")
        tocken=create_token(current_user.email)
        return {"access_token": tocken, "token_type": "bearer"}
    except HTTPException:
        raise
    except:
        db.rollback()
        raise HTTPException (status_code=500,detail="Server Error !")

    
