from datetime import UTC, datetime
from uuid import uuid4
from typing import Annotated

from pydantic import BaseModel, Field, field_validator

class AnalysisResponse(BaseModel):
    """Response model for journal entry analysis."""
    entry_id: str = Field(description="ID of the analyzed entry")
    sentiment: str = Field(description="Sentiment: positive, negative, or neutral")
    summary: str = Field(description="2 sentence summary of the entry")
    topics: list[str] = Field(description="2-4 key topics mentioned in the entry")
    created_at: datetime = Field(
        default_factory=lambda: datetime.now(UTC),
        description="Timestamp when the analysis was created"
    )



class EntryCreate(BaseModel):
    """Model for creating a new journal entry (user input)."""
    work: str = Field(
        max_length=256,
        description="What did you work on today?",
        json_schema_extra={"example": "Studied FastAPI and built my first API endpoints"}
    )
    struggle: str = Field(
        max_length=256,
        description="What's one thing you struggled with today?",
        json_schema_extra={"example": "Understanding async/await syntax and when to use it"}
    )
    intention: str = Field(
        max_length=256,
        description="What will you study/work on tomorrow?",
        json_schema_extra={"example": "Practice PostgreSQL queries and database design"}
    )

class Entry(BaseModel):
    # TODO: Add schema versioning
    # TODO: Add data sanitization methods

    # Validate fields to not have empty characters (" ")
    @field_validator("work", "struggle", "intention")
    @classmethod
    def not_blank(cls, v:str) -> str:
        v= v.strip()
        if not v:
            raise ValueError("Fields cannot be blank or whitespace only")
        return v

    id: Annotated[str ,Field(
        default_factory=lambda: str(uuid4()),
        description="Unique identifier for the entry (UUID).",
        gt=0
    )]
    work: Annotated[str ,Field(
        ...,
        min_length=1,
        max_length=256,
        description="What did you work on today?",
    )]
    struggle: Annotated[str, Field(
        ...,
        min_length=1,
        max_length=256,
        description="What’s one thing you struggled with today?",
    )]
    intention: Annotated[str, Field(
        ...,
        min_length=1,
        max_length=256,
        description="What will you study/work on tomorrow?",
    )]
    created_at: datetime | None = Field(
        default_factory=lambda: datetime.now(UTC),
        description="Timestamp when the entry was created."
    )
    updated_at: datetime | None = Field(
        default_factory=lambda: datetime.now(UTC),
        description="Timestamp when the entry was last updated."
    )
