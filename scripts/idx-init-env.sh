#!/bin/bash

poetry install
./scripts/flutter-enforce-lockfile.sh
./scripts/idx-init-db.sh
./scripts/idx-init-neo4j.sh