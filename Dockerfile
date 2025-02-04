# ──────────────────────────────────────────────────────────────────────────────
# Stage 1: Builder
# ──────────────────────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

USER root
WORKDIR /build

# Install what's needed for a venv
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
 && rm -rf /var/lib/apt/lists/*

RUN python -m venv /venv \
 && /venv/bin/pip install --upgrade pip setuptools wheel \
 && /venv/bin/pip install \
    "pytak[with_crypto]" \
    aircot \
    adsbxcot

# ──────────────────────────────────────────────────────────────────────────────
# Stage 2: Final
# ──────────────────────────────────────────────────────────────────────────────
FROM python:3.12-slim

# Create non-root user
RUN adduser --system --group --uid 1001 adsbuser

# Create /app, set it as the working directory
WORKDIR /app

# Copy the built venv from the builder
COPY --from=builder /venv /venv

# Copy your wrapper script
COPY adsbxcot-wrapper.py /app/adsbxcot-wrapper.py

# Make sure adsbuser owns /app, so it can write config.ini
RUN chown -R adsbuser:adsbuser /app

# Switch to non-root user
USER adsbuser:adsbuser

ENTRYPOINT ["/venv/bin/python", "/app/adsbxcot-wrapper.py"]
