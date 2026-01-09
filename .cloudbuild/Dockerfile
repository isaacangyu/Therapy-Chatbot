FROM python:3.11-slim AS build-env
WORKDIR /app
COPY . .

RUN pipx install poetry \
    && ./scripts/poetry-install.sh \
    && cp .env.example .env

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
COPY --from=build-env /app .

CMD ["poetry", "run", "./manage.py", "runserver"]
