#!/bin/bash

set -e

# psql -l &> /dev/null # && echo "Postgres DB already initialized."; exit 1;

# if [ -d "$/run/postgresql"]; then
#     echo "Postgres DB already initialized."
# fi

mkdir /run/postgresql # will exit if DB already created this
initdb -D .idx/postgres
# pg_ctl -D .idx/postgres -l .idx/logfile start
# psql --dbname=postgres -c "CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;"
# echo "Initialized Postgres DB"