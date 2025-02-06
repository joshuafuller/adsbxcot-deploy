# Use a minimal Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone PyTAK and ADSBXCOT repositories
RUN git clone --depth 1 https://github.com/snstac/pytak.git /app/pytak && \
    git clone --depth 1 https://github.com/snstac/adsbxcot.git /app/adsbxcot

# Update PyTAK constants for larger queue sizes
# Note: The constants file is now in /app/pytak/src/pytak/constants.py
RUN sed -i 's/DEFAULT_MAX_OUT_QUEUE = 100/DEFAULT_MAX_OUT_QUEUE = 5000/' /app/pytak/src/pytak/constants.py && \
    sed -i 's/DEFAULT_MAX_IN_QUEUE = 500/DEFAULT_MAX_IN_QUEUE = 5000/' /app/pytak/src/pytak/constants.py

# Install PyTAK and ADSBXCOT
RUN pip install --no-cache-dir /app/pytak /app/adsbxcot

# Copy the wrapper script for dynamic configuration
COPY adsbxcot-wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/adsbxcot-wrapper.sh

# Set the entry point to the wrapper script
ENTRYPOINT ["adsbxcot-wrapper.sh"]
