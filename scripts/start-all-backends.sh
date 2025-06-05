#!/bin/bash

set -e

# Note: Background tasks are automatically terminated when the VSCode task ends.

if [ -n "$IDX_CHANNEL" ]; then
    ./scripts/start-api-test-backend.py &
    ./scripts/start-backend.sh &
    ./scripts/idx-start-postgres.sh
    ./scripts/idx-start-neo4j.sh # Keep alive.

    ./scripts/idx-stop-postgres.sh
else
    ./scripts/start-api-test-backend.py &
    ./scripts/start-backend.sh # Keep alive.
fi
