#!/bin/bash

./scripts/poetry-install.sh
./scripts/flutter-enforce-lockfile.sh
./scripts/idx-init-db.sh
./scripts/idx-init-neo4j.sh
