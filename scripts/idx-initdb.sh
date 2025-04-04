#!/bin/bash

set -e

mkdir /run/postgresql
initdb -D .idx/postgres
pg_ctl -D .idx/postgres -l .idx/logfile start
psql --dbname=postgres -c "CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;"
