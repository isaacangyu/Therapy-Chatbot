#!/bin/bash

# Equivalent to Ctrl-C on task "Start All Backends".

./scripts/idx-stop-neo4j.sh
./scripts/idx-stop-redis.sh
./scripts/idx-stop-postgres.sh
