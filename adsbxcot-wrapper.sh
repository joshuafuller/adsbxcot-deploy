#!/bin/bash

# Default values
COT_URL=${COT_URL:-"tcp://192.168.100.100:8088"}
FEED_URL=${FEED_URL:-"https://api.airplanes.live/v2/mil"}
POLL_INTERVAL=${POLL_INTERVAL:-10}
API_KEY=${API_KEY:-"none"}
DEBUG=${DEBUG:-0}
COT_STALE=${COT_STALE:-120}

# Generate a dynamic config.ini
cat <<EOF > /app/config.ini
[adsbxcot]
TAK_PROTO = 0
COT_URL = $COT_URL
POLL_INTERVAL = $POLL_INTERVAL
FEED_URL = $FEED_URL
API_KEY = $API_KEY
DEBUG = $DEBUG
COT_STALE = $COT_STALE
EOF

# Run adsbxcot with the generated config
exec adsbxcot -c /app/config.ini
