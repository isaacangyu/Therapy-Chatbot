#!/bin/bash

echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc

pipx install poetry && poetry install

clear && echo "devcontainer configuration complete."
