FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_NAME=cloud-run-cicd \
    APP_VERSION=local \
    APP_ENV=local

WORKDIR /app

# Dependencies layer
COPY pyproject.toml README.md ./
RUN pip install --upgrade pip && pip install .

# Application layer
COPY src/app ./app

EXPOSE ${APP_PORT:-8000}
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${APP_PORT:-8000}"]