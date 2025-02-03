FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy local folders
COPY pytak /app/pytak
COPY adsbxcot /app/adsbxcot

# (Optional) Upgrade pip, setuptools, and wheel
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Optionally tweak PyTAK's constants
RUN sed -i 's/DEFAULT_MAX_OUT_QUEUE = 100/DEFAULT_MAX_OUT_QUEUE = 5000/' /app/pytak/src/pytak/constants.py && \
    sed -i 's/DEFAULT_MAX_IN_QUEUE = 500/DEFAULT_MAX_IN_QUEUE = 5000/' /app/pytak/src/pytak/constants.py

# Install pytak
RUN cd /app/pytak && pip install --no-cache-dir .

# Install adsbxcot
RUN cd /app/adsbxcot && pip install --no-cache-dir .

# Copy the wrapper script (if you need it)
COPY adsbxcot-wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/adsbxcot-wrapper.sh

ENTRYPOINT ["adsbxcot-wrapper.sh"]
