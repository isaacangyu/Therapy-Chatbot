#!/bin/bash

# This directory may be automatically removed by the environment, sometimes.
mkdir /run/postgresql &> /dev/null

MAX_ITERATIONS=5
ITERATION=0

pg_ctl -D .idx/postgres -l .idx/logfile start &
psql --dbname=postgres -c "CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;"
echo "Initialized Postgres DB"

echo "Waiting to connect to database server..."
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/5432" &> /dev/null; do
    ITERATION=$((ITERATION + 1))
    if [ $ITERATION -ge $MAX_ITERATIONS ]; then
        echo "Unable to connect to database server."
        exit 1
    fi
    sleep 1
done
echo "Connected to database server."

if psql --dbname=postgres -U postgres -c '\q'; then
    echo "Database started successfully."
else
    echo "Database is listening on port 5432, but did not start successfully."
    exit 1
fi
