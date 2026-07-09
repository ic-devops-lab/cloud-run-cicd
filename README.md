# cloud-run-cicd
Demo project demonstrating CI/CD workflow for a Cloud Run service

## Project setup

```bash
# install and activate virtual environment
python -m venv .venv
source .venv/bin/activate
(.venv) python -m pip install --upgrade pip
```
> All further shell commands assumed to be executed with activated virtual environment

```bash
# install dependencies from pyproject.toml
pip install -e
# pip install -e ".[dev]"   # fo later when we have dev deps
```

---

## Running the project locally

- From the code
```bash
export HOST="0.0.0.0"
export PORT="8000"
export APP_MODULE="app.main:app"
uvicorn $APP_MODULE --host $HOST --port $PORT --reload
```

---

## Sources

- https://docs.cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-python-fastapi-service

---
