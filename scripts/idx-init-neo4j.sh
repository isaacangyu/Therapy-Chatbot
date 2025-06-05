#!/bin/bash

# Neo4j CLI: https://neo4j.com/docs/operations-manual/current/neo4j-admin-neo4j-cli/

source ./scripts/idx-neo4j-env.sh

echo $NEO4J_HOME
echo $NEO4J_CONF

neo4j-admin dbms set-initial-password neo4j_pswd
