import logging

from fastapi import FastAPI
from opentelemetry import metrics, trace
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

from api.routers.journal_router import router as journal_router
from api.telemetry import initialize_metrics, logger1

app = FastAPI(
    title="Journal API",
    description="A simple journal API for tracking daily work, struggles, and intentions",
)

# Tracing setup
resource = Resource.create(attributes={"service.name": "journal-api"})
provider = TracerProvider(resource=resource)
provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(insecure=True)))
trace.set_tracer_provider(provider)
tracer = trace.get_tracer("journal-api.tracer")

# Metrics setup
# Point at Aspire Dashboard's OTLP gRPC port
exporter = OTLPMetricExporter(
    insecure=True,  # no TLS for local dev
)
reader = PeriodicExportingMetricReader(exporter, export_interval_millis=5000)
provider_meter = MeterProvider(metric_readers=[reader], resource=resource)
metrics.set_meter_provider(provider_meter)
create_entries_counter = initialize_metrics()

FastAPIInstrumentor.instrument_app(app)

# Logging setup
logger_provider = LoggerProvider(resource=resource)
logger_provider.add_log_record_processor(BatchLogRecordProcessor(OTLPLogExporter(insecure=True)))
handler = LoggingHandler(level=logging.NOTSET, logger_provider=logger_provider)

logging.getLogger().addHandler(handler)
logging.getLogger().setLevel(logging.NOTSET)
logging.getLogger().propagate = False

logger1.info("Journal API started")

app.include_router(journal_router)
