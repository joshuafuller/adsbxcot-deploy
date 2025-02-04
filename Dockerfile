# Use the latest development version of the Chainguard Python image as the builder
FROM cgr.dev/chainguard/python:latest-dev AS builder

# Switch to the root user
USER root

# Set the working directory for the build process
WORKDIR /build

# Create a virtual environment and install necessary Python packages
RUN python -m venv /venv \
 && /venv/bin/pip install --upgrade pip setuptools wheel \
 && /venv/bin/pip install \
    "pytak[with_crypto]" \
    aircot \
    adsbxcot

# Use the latest stable version of the Chainguard Python image for the final image
FROM cgr.dev/chainguard/python:latest

# Set the working directory for the application
WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /venv /venv

# Copy the application script into the image
COPY adsbxcot-wrapper.py /app/adsbxcot-wrapper.py

# Set the entry point to run the application script using the Python interpreter from the virtual environment
ENTRYPOINT ["/venv/bin/python", "/app/adsbxcot-wrapper.py"]
