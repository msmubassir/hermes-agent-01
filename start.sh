#!/bin/bash
set -e

PORT="${PORT:-10000}"

# Hermes dashboard
hermes dashboard \
  --host 0.0.0.0 \
  --port "${PORT}" \
  --insecure \
  --no-open &
  
# Download ttyd if missing
if [ ! -f /usr/local/bin/ttyd ]; then
  curl -L \
    https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -o /usr/local/bin/ttyd

  chmod +x /usr/local/bin/ttyd
fi

# Keep container alive
sleep infinity
