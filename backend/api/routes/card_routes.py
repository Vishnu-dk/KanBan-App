from fastapi import APIRouter,Depends,HTTPException
from sqlalchemy.orm import Session
from api.depends.database import get_db
from api.depends.auth import get_user
from api.schema.user_schema import UserCurrent
from api.modals.card_modal import Card
from api.schema.card_schema import CardCreate,CardUpdate
from datetime import datetime ,timezone

router=APIRouter()

@router.get("/cards")
def get_card_details(column_id:str, db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        cards = db.query(Card).filter(Card.column_id == column_id).order_by(Card.position.asc()).all()
        if not cards:
            return []
        return cards
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,detail=str(e))
@router.post("/cards")
def add_card_details( card:CardCreate, db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
        cards=db.query(Card).filter(Card.title==card.title,Card.column_id==card.column_id).all()
        cards_count=db.query(Card).filter(Card.column_id==card.column_id).count()
        if  cards:
            raise HTTPException(status_code=404,detail="Card Title already in use")

        new_card=Card(title=card.title,due_date=card.due_date,column_id=card.column_id,description=card.description, position=cards_count)
        db.add(new_card)
        db.commit()
        db.refresh(new_card)
        return "Card Added"
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500,detail=str(e))
    

@router.delete("/cards/{card_id}")
def delete_card_details(card_id: str, db: Session = Depends(get_db), current_user: UserCurrent = Depends(get_user)):
    try:
        card = db.query(Card).filter(Card.id == card_id).first()
        if not card:
            raise HTTPException(status_code=404, detail="No Card exists")
        
        col_id = card.column_id 
        db.delete(card)
        db.flush()

        remaining_cards = db.query(Card).filter(Card.column_id == col_id).order_by(Card.position.asc()).all()
        for index, value in enumerate(remaining_cards):
            value.position = index
            
        db.commit()
        return {"message": "Card Deleted"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    

@router.patch("/cards/{card_id}")
def edit_card_details(card_id:str, card_update:CardUpdate, db:Session=Depends(get_db),current_user:UserCurrent=Depends(get_user)):
    try:
            current_card=db.query(Card).filter(card_id==Card.id).first()
            existing_card=db.query(Card).filter(card_update.title==Card.title,card_update.position!=Card.position).first()

            if not current_card:
                raise HTTPException(status_code=404,detail="Column not Found")
            if card_update.title is not None and card_update.title!=current_card.title:
                if existing_card:
                    raise HTTPException(status_code=402,detail="Column title is already in use")
                current_card.title=card_update.title
            if card_update.due_date is not None:
                current_card.due_date=card_update.due_date
            if card_update.description is not None:
                current_card.description=card_update.description
            if card_update.position is not None:
                new_position = card_update.position
                col_id = current_card.column_id
                other_cards = db.query(Card).filter(
                    Card.column_id == col_id, 
                    Card.id != current_card.id
                ).order_by(Card.position.asc()).all()

                other_cards.insert(new_position, current_card)

                for index, col in enumerate(other_cards):
                    col.position = index


            db.commit()
            db.refresh(current_card)

            return current_card


    except HTTPException:
        raise
    except Exception as e :
        db.rollback()
        raise HTTPException(status_code=500,detail=str(e))