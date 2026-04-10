from fastapi import APIRouter,Depends,HTTPException
from sqlalchemy.orm import Session
from api.depends.database import get_db
from api.depends.auth import get_user
from api.modals.user_modal import User
from api.modals.board_modal import Board
from api.schema.board_schema import BoardCreate,BoardDelete
from api.schema.user_schema import UserCurrent
from uuid import uuid4


router=APIRouter()


@router.get("/boards")
def get_board_details(db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        
        if not current_user:
            raise HTTPException(status_code=401,detail="Unauthorised Entry")
        board=db.query(Board).filter(Board.owner_id==current_user.id).all()

        return board

    except HTTPException:
        raise
    except:
        raise HTTPException(status_code=500,detail="Server Error")

@router.get("/boards/{currentId}")
def get_board_details_by_Id(currentId:str,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        
        if not current_user:
            raise HTTPException(status_code=401,detail="Unauthorised Entry")
        board=db.query(Board).filter(Board.owner_id==current_user.id,Board.id==currentId).first()

        return board

    except HTTPException:
        raise
    except:
        raise HTTPException(status_code=500,detail="Server Error")
    


@router.post("/boards")
def add_board_details(current_board:BoardCreate,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        
        if not current_user:
            raise HTTPException(status_code=401,detail="Unauthorised Entry")
        existing_board=db.query(Board).filter(Board.name==current_board.name,current_user.id==Board.owner_id).first()
        if existing_board:
            raise HTTPException(status_code=409,detail="Board Name is already in Use")
        new_board=Board(name=current_board.name,owner_id=current_user.id)
        db.add(new_board)
        db.commit()
        db.refresh(new_board)
        return "Board Added"

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500,detail=e)


@router.delete("/boards/{current_board_id}")
def delete_board_details(current_board_id:str,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        if not current_user:
            raise HTTPException(status_code=401,detail="Unauthorised Entry")
        existing_board=db.query(Board).filter(Board.id==current_board_id,Board.owner_id==current_user.id).first()
        if not existing_board:
            raise HTTPException(status_code=402,detail="Board Not Found")
        db.delete(existing_board)
        db.commit()
        return "Board Deleted"

    except HTTPException:
        raise
    except:
        db.rollback()

        raise HTTPException(status_code=500,detail="Server Error")