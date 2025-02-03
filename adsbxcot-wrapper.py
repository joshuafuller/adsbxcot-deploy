#!/usr/bin/env python3

import os
import subprocess

# Environment variables with defaults
cot_url = os.getenv("COT_URL", "tcp://10.10.10.233:8088")
adsbx_url = os.getenv("ADSBX_URL", "https://api.airplanes.live/v2/point/40.7128/-74.0060/50")
poll_interval = os.getenv("POLL_INTERVAL", "10")
api_key = os.getenv("API_KEY", "none")
debug = os.getenv("DEBUG", "0")
cot_stale = os.getenv("COT_STALE", "120")

# Config file content
config_content = f"""[adsbxcot]
TAK_PROTO = 0
COT_URL = {cot_url}
POLL_INTERVAL = {poll_interval}
ADSBX_URL = {adsbx_url}
API_KEY = {api_key}
DEBUG = {debug}
COT_STALE = {cot_stale}
"""

# Write config file
config_path = "/app/config.ini"
with open(config_path, "w") as config_file:
    config_file.write(config_content)

print(f"Config file written to {config_path}")

# Run adsbxcot with the generated config
try:
    print("Starting adsbxcot...")
    subprocess.run(["adsbxcot", "-c", config_path], check=True)
except FileNotFoundError:
    print("Error: adsbxcot binary not found. Make sure it is installed inside the container.")
except subprocess.CalledProcessError as e:
    print(f"adsbxcot exited with error: {e}")
