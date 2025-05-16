#!/bin/bash

# Start dummy HTTP server in the background
python3 -m http.server 8080 &

# Infinite tmate session restarter
while true; do
    echo "Starting tmate..."
    tmate -F || echo "Tmate exited. Restarting in 5s..."
    sleep 5
done
