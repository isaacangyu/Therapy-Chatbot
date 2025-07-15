#!/bin/bash

poetry install
./scripts/flutter-enforce-lockfile.sh
./scripts/idx-initdb.sh