FROM python:3.11-slim AS build-env
WORKDIR /app
COPY . .

RUN python -m venv .venv \
    && ./.venv/bin/pip install poetry \
    && ./.venv/bin/poetry config virtualenvs.create false --local \
    && ./.venv/bin/poetry install --no-interaction --no-ansi

CMD [ "/app/.venv/bin/daphne", "therapy_chatbot.asgi:application" ]
