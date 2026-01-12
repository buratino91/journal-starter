from prometheus_client import Counter, Gauge

request_counter = Counter(
    "post_requests_total",
    "Total number of requests to the endpoint",
    ["endpoint"],
)


entry_gauge = Gauge(
    "total_number_of_entries",
    "Total number of entries in database",
    
)