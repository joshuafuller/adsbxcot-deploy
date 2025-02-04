#!/usr/bin/env python3

import os
import subprocess

# Retrieve environment variables or use default values if not set
cot_url = os.getenv("COT_URL", "tcp://10.10.10.233:8088")
feed_url = os.getenv("FEED_URL", "https://api.airplanes.live/v2/point/40.7128/-74.0060/50")
poll_interval = os.getenv("POLL_INTERVAL", "10")
api_key = os.getenv("API_KEY", "none")
debug = os.getenv("DEBUG", "0")
cot_stale = os.getenv("COT_STALE", "120")

# Create a configuration string using the retrieved environment variables
config_content = f"""[adsbxcot]
TAK_PROTO = 0
COT_URL = {cot_url}
FEED_URL = {feed_url}
POLL_INTERVAL = {poll_interval}
API_KEY = {api_key}
DEBUG = {debug}
COT_STALE = {cot_stale}
"""

# Define the path where the configuration file will be written
config_path = "/app/config.ini"

# Write the configuration content to the specified file
with open(config_path, "w") as config_file:
    config_file.write(config_content)

# Inform the user that the configuration file has been written
print(f"Config file written to {config_path}")
print("Starting adsbxcot...")

try:
    # Attempt to run the adsbxcot command with the generated configuration file
    subprocess.run(["/venv/bin/adsbxcot", "-c", config_path], check=True)
except FileNotFoundError:
    # Handle the case where the adsbxcot executable is not found
    print("Error: /venv/bin/adsbxcot not found. Is adsbxcot installed?")
except subprocess.CalledProcessError as e:
    # Handle errors that occur during the execution of the adsbxcot command
    print(f"adsbxcot exited with error: {e}")
