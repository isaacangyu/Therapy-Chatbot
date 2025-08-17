#!/bin/bash

source ./scripts/idx-neo4j-env.sh

# For some reason, `neo4j start` terminates the server immediately.
# So does `neo4j console &`.
neo4j console
