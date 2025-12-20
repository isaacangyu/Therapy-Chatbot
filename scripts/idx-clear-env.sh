#!/bin/bash

./scripts/idx-delete-neo4j.sh
./scripts/idx-delete-db.sh
rm -r ~/.cache/pypoetry # Other cache directories: .pub-cache, .gradle
flutter clean
