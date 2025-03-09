from fastapi import APIRouter

from db.models import UserInput  # Import from models.py
from repository.predection_repository import predict_disease

router = APIRouter(
    prefix="/prediction",
    tags=["prediction"],
)


@router.post("/predict")
def predict(user_input: UserInput):
    return predict_disease(user_input)
