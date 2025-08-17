#!/bin/bash

set -e

mkdir /run/postgresql # will exit if DB already created
initdb -D .idx/postgres
echo "Initialized Postgres DB"