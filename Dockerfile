ARG DEPS=prod


FROM python:3.12 AS base-prod

RUN apt-get update && apt-get install -yq curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV POETRY_HOME=/opt/poetry

RUN curl -sSl https://install.python-poetry.org | python3 -

ENV PATH="$PATH:$POETRY_HOME/bin"


RUN poetry config virtualenvs.create false \
    && poetry config cache-dir /cache/poetry

WORKDIR /app
COPY pyproject.toml poetry.lock README.md ./

RUN --mount=type=cache,target=/cache/poetry \
    poetry install --only main


FROM base-prod AS base-dev

RUN poetry install --only dev


FROM base-${DEPS} AS final
COPY . .
RUN poetry install

CMD ["bash","-c"]
CMD ["./docker-entrypoint.sh"]