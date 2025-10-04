#!/bin/bash

./scripts/idx-delete-neo4j.sh
./scripts/idx-delete-db.sh
# rm -rf .idx/postgres/ /run/postgresql/
rm -r ~/.cache
flutter clean