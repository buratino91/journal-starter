import logging

from opentelemetry import metrics, trace

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
