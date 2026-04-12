#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd "$(dirname "$0")"

nvm use 22

echo "Starting Floss Jobs dev server..."

npm run dev > .server.log 2>&1 &
PID=$!
echo $PID > .server.pid

echo "Server is starting up (PID: $PID)... waiting for it to be ready."
sleep 5

echo "Opening http://localhost:3000 in Google Chrome..."
open -a "Google Chrome" "http://localhost:3000"

echo "Done! Run ./stop_server.sh to stop it later."
