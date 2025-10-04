#!/bin/bash

set -e

# Note: Background tasks are automatically terminated when the VSCode task ends.

if [ -n "$IDX_CHANNEL" ]; then
    ./scripts/start-api-test-backend.py &
    ./scripts/idx-start-redis.sh # Already daemonized.
    ./scripts/idx-start-postgres.sh
    ./scripts/django-migrate.sh
    ./scripts/start-backend.sh &
    ./scripts/idx-start-neo4j.sh # Keep alive.
    # Neo4j stopped on Ctrl-C.
    ./scripts/idx-stop-postgres.sh
    ./scripts/idx-stop-redis.sh
else
    ./scripts/start-api-test-backend.py &
    ./scripts/start-backend.sh # Keep alive.
fi
