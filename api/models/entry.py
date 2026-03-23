from datetime import UTC, datetime
from uuid import uuid4
from typing import Annotated

from pydantic import BaseModel, Field, Aware

import re

VALID_FIELDS_REGEX = re.compile(r"^[A-Za-z0-9\s.,!?\-'\"]+$")

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
    # TODO: Add field validation rules
    # TODO: Add custom validators
    # TODO: Add schema versioning
    # TODO: Add data sanitization methods

    id: Annotated[str ,Field(
        default_factory=lambda: str(uuid4()),
        description="Unique identifier for the entry (UUID).",
        gt=0
    )]
    work: Annotated[str ,Field(
        ...,
        max_length=256,
        description="What did you work on today?",
        pattern=VALID_FIELDS_REGEX
    )]
    struggle: Annotated[str, Field(
        ...,
        max_length=256,
        description="What’s one thing you struggled with today?",
        pattern=VALID_FIELDS_REGEX
    )]
    intention: Annotated[str, Field(
        ...,
        max_length=256,
        description="What will you study/work on tomorrow?",
        pattern=VALID_FIELDS_REGEX
    )]
    created_at: datetime | None = Field(
        default_factory=lambda: datetime.now(UTC),
        description="Timestamp when the entry was created."
    )
    updated_at: datetime | None = Field(
        default_factory=lambda: datetime.now(UTC),
        description="Timestamp when the entry was last updated."
    )
