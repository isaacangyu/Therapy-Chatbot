#!/bin/bash

# Create patches with `diff -uN original modified > changes.patch`.

patch /home/vscode/.cache/pypoetry/virtualenvs/therapy-chatbot-*-py3.11/lib/python3.11/site-packages/graphiti_core/utils/bulk_utils.py < chatbot/bulk_utils.patch
