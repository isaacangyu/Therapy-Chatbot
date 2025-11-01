#!/bin/bash

PID=$(pgrep -f "docker-android start device")

if [ -z "$PID" ]; then
    echo "No running emulator found."
else
    echo "Found emulator | PID: ${PID}"
    kill -9 $PID
fi

echo "Starting emulator."
docker-android start device
