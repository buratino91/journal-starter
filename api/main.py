import logging

from fastapi import FastAPI
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

from api.routers.journal_router import router as journal_router
from api.telemetry import initialize_telemetry, logger1

app = FastAPI(
    title="Journal API",
    description="A simple journal API for tracking daily work, struggles, and intentions",
)

tracer = initialize_telemetry(service_name="journal-api")

FastAPIInstrumentor.instrument_app(app)

root_logger = logging.getLogger()
root_logger.setLevel(logging.INFO)

stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.INFO)

formatter = logging.Formatter("%(asctime)s %(levelname)s %(name)s %(message)s")
stream_handler.setFormatter(formatter)

root_logger.addHandler(stream_handler)

logger1.info("Journal API started")

app.include_router(journal_router)
