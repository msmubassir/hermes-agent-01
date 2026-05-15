#!/bin/bash
set -e

PORT="${PORT:-10000}"

# Hermes dashboard
hermes dashboard \
  --host 127.0.0.1 \
  --port 9119 \
  --insecure \
  --no-open &

# Download ttyd if missing
if [ ! -f /opt/data/ttyd ]; then
  curl -L \
    https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -o /opt/data/ttyd

  chmod +x /opt/data/ttyd
fi

# Terminal backend (internal only)
/opt/data/ttyd \
  --writable \
  --interface 127.0.0.1 \
  --port 7681 \
  bash &

# Python deps
uv pip install flask requests

# Start public proxy server
export FLASK_APP=proxy.py
flask run --host=0.0.0.0 --port="${PORT}"
