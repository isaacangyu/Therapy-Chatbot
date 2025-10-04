#!/bin/bash
# Equivalent to Ctrl-C on start-all-backends

./scripts/idx-stop-neo4j.sh
./scripts/idx-stop-redis.sh
./scripts/idx-stop-postgres.sh