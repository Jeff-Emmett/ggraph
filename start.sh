#!/bin/sh

# Start y-websocket server in background
echo "Starting y-websocket server on port 1234..."
HOST=0.0.0.0 PORT=1234 npx y-websocket &

# Start nginx in foreground
echo "Starting nginx on port 80..."
nginx -g 'daemon off;'
