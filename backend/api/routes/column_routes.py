


from fastapi import APIRouter,Depends,HTTPException
from sqlalchemy.orm import Session
from api.depends.database import get_db
from api.depends.auth import get_user
from api.modals.user_modal import User
from api.modals.board_modal import Board
from api.modals.column_modal import Column
from api.schema.column_schema import ColumnCreate,ColumnUpdate
from api.schema.user_schema import UserCurrent

router=APIRouter()


@router.get("/columns")
def get_column_details(board_id=str,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        current_board=db.query(Board).filter(Board.id==board_id,Board.owner_id==current_user.id).first()
        current_column=db.query(Column).filter(Column.board_id==current_board.id).all()

        if not current_column:
            raise HTTPException(status_code=404,detail="No cloumn as of now")
        return current_column
    except HTTPException:
        raise
    except :
        raise HTTPException(status_code=500,detail="Server Error")
    

@router.post("/columns")
def add_column_details(column:ColumnCreate,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        current_board=db.query(Board).filter(Board.id==column.board_id,Board.owner_id==current_user.id).first()
        current_column=db.query(Column).filter(Column.title==column.name,Column.board_id==current_board.id).first()
        current_count=db.query(Column).filter(Column.board_id==column.board_id).count()
        if current_column:
            raise HTTPException(status_code=404,detail="Column name has been already used")
        data=Column(title=column.name,board_id=column.board_id,position=current_count)

        db.add(data)
        db.commit()
        db.refresh(data)

        return "Column Added"
    except HTTPException:
        raise
    except Exception as e :
        db.rollback()
        raise HTTPException(status_code=500,detail="Server Error")
    
@router.delete("/columns/{column_id}")
def delete_column_details(column_id:str,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:

        current_column=db.query(Column).filter(Column.id==column_id).first()

        if not current_column:
            raise HTTPException(status_code=404,detail="Column not Found")
        db.delete(current_column)
        db.flush()
        columns=db.query(Column).filter(current_column.board_id==Column.board_id).all()
        for index,value in enumerate(columns):
            value.position=index
        db.commit()
        return "Column Deleted"
    except HTTPException:
        raise
    except Exception as e :
        db.rollback()
        raise HTTPException(status_code=500,detail="Server Error")
    
@router.patch("/columns/{column_id}")
def edit_column_details(column_id:str,column_update:ColumnUpdate,db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        current_column=db.query(Column).filter(column_id==Column.id).first()
        existing_column=db.query(Column).filter(column_update.name==Column.title,column_update.position!=Column.position).first()

        if not current_column:
            raise HTTPException(status_code=404,detail="Column not Found")
        if column_update.name is not None:
            if existing_column:
                raise HTTPException(status_code=402,detail="Column title is already in use")
            current_column.title=column_update.name
        if column_update.position is not None and column_update.position != current_column.position:
            new_position=column_update.position
            board_id=current_column.board_id

            other_columns = db.query(Column).filter(
                                Column.board_id == board_id, 
                                Column.id != current_column.id
                            ).order_by(Column.position.asc()).all()

            other_columns.insert(new_position,current_column)

            for index,col in enumerate(other_columns):
                col.position=index

        db.commit()
        db.refresh(current_column)

        return current_column
        

    except HTTPException:
        raise
    except Exception as e :
        db.rollback()
        raise HTTPException(status_code=500,detail="Server Error")
    

