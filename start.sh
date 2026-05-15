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

# Download ttyd if missing
if [ ! -f /usr/local/bin/ttyd ]; then
  curl -L \
    https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -o /usr/local/bin/ttyd

  chmod +x /usr/local/bin/ttyd
fi

# Web terminal
/usr/local/bin/ttyd \
  --port 7681 \
  bash &

# Start nginx
nginx -g 'daemon off;'
