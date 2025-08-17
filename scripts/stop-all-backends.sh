#!/bin/bash

./scripts/clear-graphiti-data.py
./scripts/idx-stop-neo4j.sh
./scripts/idx-stop-redis.sh
./scripts/idx-stop-postgres.sh