#!/bin/bash

./scripts/stop-neo4j.sh
./scripts/clear-graphiti-data.py
./scripts/stop-redis.sh
./scripts/stop-postgres.sh