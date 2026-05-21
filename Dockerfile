# exact version for reproducibility
FROM python:3.14-slim-bookworm AS builder 

# COPY UV binary from official image
COPY --from=ghcr.io/astral-sh/uv:0.11.6 /uv /uvx /bin/

WORKDIR /app

# Install dependencies first (Docker optimization trick: COPY dependencies first, then source code)
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-install-project --no-dev

# Copy app code and install project
COPY . ./
RUN uv sync --locked --no-dev

# Production 
FROM python:3.14-slim-bookworm

WORKDIR /app

# Run as non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Copy app and dependencies from builder stage
COPY --from=builder --chown=appuser:appuser /app /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PORT=8000

EXPOSE 8000

# exec ensures the app receives signals properly (e.g., for graceful shutdown)
CMD ["/bin/sh", "-c", "exec uvicorn api.main:app --reload --host 0.0.0.0 --port $PORT"]