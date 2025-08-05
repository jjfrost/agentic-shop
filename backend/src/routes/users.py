from typing import List

from fastapi import APIRouter, HTTPException, Request
from src.database import DBSession
from src.repository import UserRepository
from src.schemas.users import UserResponseSchema

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)


@router.get("/", response_model=List[UserResponseSchema])
async def get_all_users(db: DBSession):
    users = await UserRepository(db).get_all()
    return users


@router.get("/me", response_model=UserResponseSchema)
async def get_user(request: Request, db: DBSession):
    user = await UserRepository(db).get_by_id(request.state.user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponseSchema.model_validate(user)
