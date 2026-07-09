FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_NAME=cloud-run-cicd \
    APP_VERSION=local \
    APP_ENV=local \
    PORT=${PORT:-8080}

WORKDIR /app

# Dependencies layer
COPY pyproject.toml README.md ./
RUN pip install --upgrade pip && pip install .

# Application layer
COPY src/app ./app

EXPOSE ${PORT:-8080}
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8080}"]