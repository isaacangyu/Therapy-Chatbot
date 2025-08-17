#!/bin/bash

set -e

# Note: Background tasks are automatically terminated when the VSCode task ends.

if [ -n "$IDX_CHANNEL" ]; then
    ./scripts/start-api-test-backend.py &
    ./scripts/idx-start-redis.sh # already daemonized
    ./scripts/django-migrate.sh
    ./scripts/start-backend.sh &
    ./scripts/idx-start-neo4j.sh # Keep alive.

    ./scripts/idx-stop-postgres.sh
    ./scripts/idx-stop-redis.sh
else
    ./scripts/start-api-test-backend.py &
    ./scripts/start-backend.sh # Keep alive.
fi
