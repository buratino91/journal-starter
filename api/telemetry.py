import logging

from opentelemetry import metrics, trace
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

logger1 = logging.getLogger("journal-api")
tracer = trace.get_tracer("journal-api.tracer")
create_entries_counter = None


def initialize_metrics():
    global create_entries_counter
    if create_entries_counter is None:
        meter = metrics.get_meter("journal-api.metrics", "1.0.0")
        create_entries_counter = meter.create_counter(
            "num_created_entries",
            unit="1",
            description="Counts the number of journal entries created",
        )
    return create_entries_counter


def get_create_entries_counter():
    return initialize_metrics()


# TODO: refactor telemetry.py
def initialize_telemetry(service_name: str = "journal-api"):
    # Metrics setup
    exporter = OTLPMetricExporter(
        insecure=True,  # no TLS for local dev
    )
    # Create Resource
    resource = Resource.create(attributes={"service.name": service_name})

    reader = PeriodicExportingMetricReader(exporter, export_interval_millis=5000)
    # Initialize MeterProvider
    provider_meter = MeterProvider(metric_readers=[reader], resource=resource)
    # Set the global meter provider
    metrics.set_meter_provider(provider_meter)

    # Tracing setup
    tracer_provider = TracerProvider(resource=resource)
    tracer_provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(insecure=True)))
    trace.set_tracer_provider(tracer_provider)
    tracer = trace.get_tracer(f"{service_name}.tracer")

    # Logging setup
    logger_provider = LoggerProvider(resource=resource)
    logger_provider.add_log_record_processor(
        BatchLogRecordProcessor(OTLPLogExporter(insecure=True))
    )
    handler = LoggingHandler(level=logging.NOTSET, logger_provider=logger_provider)

    logging.getLogger().addHandler(handler)

    return tracer
