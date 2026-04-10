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
            raise HTTPException(status_code=409,detail="Card Title already in use")

        new_card=Card(title=card.title,due_date=card.due_date,column_id=card.column_id,description=card.description, position=cards_count)
        db.add(new_card)
        db.commit()
        db.refresh(new_card)
        return "Card Added"
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500,detail="Internal Server Error")
    

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
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail="Internal Server Error")

@router.patch("/cards/{card_id}")
def edit_card_details(card_id: str, card_update: CardUpdate, db: Session = Depends(get_db)):
    try:
        current_card = db.query(Card).filter(Card.id == card_id).first()
        if not current_card:
            raise HTTPException(status_code=404, detail="Card not found")

        if card_update.title:
            title=db.query(Card).filter(Card.id!=card_id,card_update.title==Card.title,Card.column_id==card_update.column_id).all()
            if  title:
                raise HTTPException(status_code=409,detail="Card Title already in use")
            current_card.title = card_update.title
        if card_update.description is not None:
            current_card.description = card_update.description
        if card_update.due_date:
            current_card.due_date = card_update.due_date

        old_column_id = current_card.column_id
        old_position = current_card.position
        new_column_id = card_update.column_id or old_column_id
        new_position = card_update.position if card_update.position is not None else old_position

        if old_column_id != new_column_id or old_position != new_position:

            if old_column_id != new_column_id:  #if both column id is different then
                db.query(Card).filter(          # select the cards after the current and and make its position no -1
                    Card.column_id == old_column_id,
                    Card.position > old_position
                ).update({Card.position: Card.position - 1})


                db.query(Card).filter(
                    Card.column_id == new_column_id,  
                    Card.position >= new_position  # select the cards after the new position of the new column and make it position +1
                ).update({Card.position: Card.position + 1})

                current_card.column_id = new_column_id
            
            else:
                if new_position > old_position:   # if in same column and new position greater than old
                    db.query(Card).filter(
                        Card.column_id == old_column_id,
                        Card.position > old_position,   # select the card after the old position
                        Card.position <= new_position   # select the card before the new position and new position
                    ).update({Card.position: Card.position - 1})  # decrement position by 1
                elif new_position < old_position:
                    db.query(Card).filter(          # if in same column and new position less than old
                        Card.column_id == old_column_id,    
                        Card.position >= new_position,      # select the card after the new position and new position
                        Card.position < old_position           # select the card before the old position
                    ).update({Card.position: Card.position + 1}) # increment position by 1

            current_card.position = new_position

        db.commit()
        db.refresh(current_card)
        return current_card
    except HTTPException:
        raise

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail="Internal Server Error")
