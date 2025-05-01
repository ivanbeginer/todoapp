ARG DEPS=prod


FROM python:3.12 AS base-prod

RUN apt-get update && apt-get install -yq curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV POETRY_HOME=/opt/poetry

RUN curl -sSl https://install.python-poetry.org | python3 -

ENV PATH="$PATH:$POETRY_HOME/bin"


RUN poetry config virtualenvs.create false
WORKDIR /app
COPY pyproject.toml poetry.lock ./

RUN poetry install --only main --no-root


FROM base-prod AS base-dev

RUN poetry install --only dev --no-root


FROM base-${DEPS} AS final
COPY . .
RUN poetry install --no-root