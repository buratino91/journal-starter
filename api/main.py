from fastapi import FastAPI, Response
from dotenv import load_dotenv
from routers.journal_router import router as journal_router
from core.logging import setup_logging
from prometheus_client import make_asgi_app

load_dotenv()

# TODO: Setup basic console logging
# Hint: Use logging.basicConfig() with level=logging.INFO
# Steps:
# 1. Configure logging with basicConfig()
# 2. Set level to logging.INFO
# 3. Add console handler
# 4. Test by adding a log message when the app starts

app = FastAPI(title="Journal API", description="A simple journal API for tracking daily work, struggles, and intentions")
metrics_app = make_asgi_app()

app.mount("/metrics", metrics_app)
app.include_router(journal_router)

setup_logging()

@app.get("/")
def read_root():
    return {
        "message": "Server is running."
    }

