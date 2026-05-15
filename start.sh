#!/bin/bash
set -e

PORT="${PORT:-10000}"

# Hermes dashboard
hermes dashboard \
  --host 127.0.0.1 \
  --port 9119 \
  --insecure \
  --no-open &

# Web terminal
ttyd \
  --port 7681 \
  bash &

# Start nginx
nginx -g 'daemon off;'
