
# TODO: Import your chosen LLM SDK
# from openai import OpenAI
# import anthropic
# import boto3
# from google.cloud import aiplatform

client = OpenAI(base_url="https://models.github.ai/inference", api_key=os.environ["GITHUB_TOKEN"])
load_dotenv(override=True)
MODEL_NAME = os.getenv("GITHUB_MODEL", "openai/gpt-4o")

class EntryAnalysis(BaseModel):
    sentiment: str
    summary: str
    topics: list[str]

async def analyze_journal_entry(entry_id: str, entry_text: str) -> dict:

    response = client.beta.chat.completions.parse(
        model=MODEL_NAME,
        messages=[
            {
                "role": "system",
                "content": "You are a helpful assistant that analyzes journal entries. Extract the following information from the entry: 1. sentiment. 2. summary. 3. topics",

            },
            {
                "role": "user",
                "content": entry_text
            },
        ],
        response_format=EntryAnalysis,
    )

    event = response.choices[0].message.parsed

    return {
        "entry_id": entry_id,
        "sentiment": event.sentiment.lower(),
        "summary": event.summary,
        "topics": event.topics,
    }

  
