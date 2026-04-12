#!/bin/bash

cd "$(dirname "$0")"

if [ -f .server.pid ]; then
  PID=$(cat .server.pid)
  echo "Stopping server (PID: $PID)..."
  kill $PID 2>/dev/null
  rm .server.pid
  echo "Server stopped."
else
  echo "No .server.pid found. Attempting to forcefully kill any nuxt processes..."
fi

pkill -f "nuxt dev" 2>/dev/null
pkill -f "nitro" 2>/dev/null

echo "All Floss Jobs dev servers should now be stopped."
