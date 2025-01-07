#!/bin/bash

./scripts/start-api-test-backend.py &
./scripts/start-backend.sh &

# Wait for servers to start in case the frontend immediately sends a request.
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/5000"; do sleep 1; done
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/8000"; do sleep 1; done

./scripts/start-frontend.sh
