#!/bin/bash

poetry install
./scripts/flutter-enforce-lockfile.sh
./scripts/idx-initdb.sh
./scripts/idx-start-postgres.sh