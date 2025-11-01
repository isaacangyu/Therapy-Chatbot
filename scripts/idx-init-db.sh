#!/bin/bash

./scripts/idx-delete-db.sh

set -e

mkdir /run/postgresql # Will exit if DB was already created.
initdb -D .idx/postgres
echo "Initialized Postgres DB"
