#!/bin/bash

echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc
pip3 install --user -r requirements.txt

/usr/local/flutter/bin/flutter create .
django-admin startproject $(basename "$PWD") .

clear && echo "devcontainer configuration complete."
