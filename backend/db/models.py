from pydantic import BaseModel


class UserInput(BaseModel):
    description: str  # User's natural language input
