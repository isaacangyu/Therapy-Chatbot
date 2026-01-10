FROM python:3.11-slim AS build-env
WORKDIR /app
COPY . .

RUN python -m venv .venv \
    && ./.venv/bin/pip install poetry \
    && ./.venv/bin/poetry config virtualenvs.create false --local \
    && ./.venv/bin/poetry install --no-interaction --no-ansi

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
COPY --from=build-env /app .

ENV PYTHONPATH="/app/.venv/lib/python3.11/site-packages"
CMD [ "./manage.py", "runserver" ]
