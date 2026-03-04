import os

from dotenv import load_dotenv
from fastapi import HTTPException
from openai import OpenAI
from pydantic import BaseModel

# TODO: Import your chosen LLM SDK
# from openai import OpenAI
# import anthropic
# import boto3
# from google.cloud import aiplatform

load_dotenv(override=True)
API_HOST = os.getenv("API_HOST", "github")

client = OpenAI(base_url="https://models.github.ai/inference", api_key=os.environ["GITHUB_TOKEN"])
MODEL_NAME = os.getenv("GITHUB_MODEL", "openai/gpt-4o")

class EntryAnalysis(BaseModel):
    sentiment: str
    summary: str
    topics: list[str]

async def analyze_journal_entry(entry_id: str, entry_text: str) -> dict:
    """
    Analyze a journal entry using your chosen LLM API.

    Args:
        entry_id: The ID of the journal entry being analyzed
        entry_text: The combined text of the journal entry (work + struggle + intention)

    Returns:
        dict with keys:
            - entry_id: ID of the analyzed entry
            - sentiment: "positive" | "negative" | "neutral"
            - summary: 2 sentence summary of the entry
            - topics: list of 2-4 key topics mentioned
            - created_at: timestamp when the analysis was created

    TODO: Implement this function using your chosen LLM provider.
    See the Learn to Cloud curriculum for guidance on:
    - Setting up your LLM API client
    - Crafting effective prompts
    - Handling structured JSON output
    """
    try:
        completion = client.beta.chat.completions.parse(
            model=MODEL_NAME,
            messages=[
                {
                    "role": "system",
                    "content": "analyze the journal entry and extract the following information from the entry: 1. sentiment. 2. summary. 3. topics",

                },
                {
                    "role": "user",
                    "content": entry_text
                },
            ],
            response_format=EntryAnalysis,
        )

        message = completion.choices[0].message
        event = message.parsed

    except NotImplementedError:
        raise HTTPException(status_code=501, detail="LLM not yet implemented.")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")

    return {
       "entry_id": entry_id,
       "sentiment": event.sentiment.lower(),
       "summary": event.summary,
       "topics": event.topics,
    }
