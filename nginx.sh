#!/bin/bash
set -e
PORT=${PORT:-80}
sed -i -e "s,listen [[:digit:]]*,listen $PORT," nginx.app.conf
echo "Starting nginx on port $PORT..."
nginx -c /opt/mastodon/nginx.conf
