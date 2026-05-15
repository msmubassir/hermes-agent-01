#!/bin/bash
set -e

PORT="${PORT:-10000}"

cat > /etc/nginx/sites-enabled/default <<EOF
server {
    listen ${PORT};

    location / {
        proxy_pass http://127.0.0.1:9119;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }

    location /terminal/ {
        proxy_pass http://127.0.0.1:7681/;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

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
