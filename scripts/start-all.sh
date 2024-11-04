#!/bin/bash

./scripts/start-backend.sh &

# Wait for server to start in case the frontend immediately sends a request.
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/8000"; do sleep 1; done

./scripts/start-frontend.sh
