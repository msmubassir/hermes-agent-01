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

# Install nginx
apt-get update && apt-get install -y nginx

# Start nginx
nginx -g 'daemon off;'
