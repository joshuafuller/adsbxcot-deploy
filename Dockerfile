# syntax=docker/dockerfile:1.4

FROM cgr.dev/chainguard/python:latest-dev AS builder

USER root
WORKDIR /build

# Create a virtual environment
RUN python -m venv /venv \
 && /venv/bin/pip install --upgrade pip setuptools wheel \
 && /venv/bin/pip install \
    "pytak[with_crypto]==6.4.0" \
    aircot \
    adsbxcot

FROM cgr.dev/chainguard/python:latest

WORKDIR /app
COPY --from=builder /venv /venv
COPY adsbxcot-wrapper.py /app/adsbxcot-wrapper.py

ENTRYPOINT ["/venv/bin/python", "/app/adsbxcot-wrapper.py"]