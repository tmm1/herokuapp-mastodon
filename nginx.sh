#!/bin/bash
set -e
PORT=${PORT:-80}
sed -i -e "s,listen [[:digit:]]*,listen $PORT," nginx.app.conf
nginx -c /opt/mastodon/nginx.conf
