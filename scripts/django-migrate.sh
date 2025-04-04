#!/bin/bash

poetry run ./manage.py makemigrations
poetry run ./manage.py migrate
