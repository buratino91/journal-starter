
from dotenv import load_dotenv

load_dotenv(override=True)

from fastapi import FastAPI

from api.routers.journal_router import router as journal_router

import logging

logging.basicConfig(level=logging.INFO)

logger = logging.getLogger('Journal App Logger')

# Console handler
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

logger.addHandler(ch)

app = FastAPI(title="Journal API", description="A simple journal API for tracking daily work, struggles, and intentions")
app.include_router(journal_router)
logger.info('App started on http://localhost:8000.')