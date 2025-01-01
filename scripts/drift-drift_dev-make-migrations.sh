#!/bin/bash

echo -e '\e[91;1mUpdate schemaVersion(s) if necessary!\e[m'
dart run drift_dev make-migrations
