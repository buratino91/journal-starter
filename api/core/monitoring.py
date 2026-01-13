from prometheus_client import Counter, Gauge, Histogram

request_counter = Counter(
    "post_requests_total",
    "Total number of requests to the endpoint",
    ["endpoint", "method", "status_code"],
)


entry_gauge = Gauge(
    "total_number_of_entries",
    "Total number of entries in database",
    
)

request_latency = Histogram(
    "http_request_latency_seconds",
    "Request latency in seconds",
    ["endpoint"]
)