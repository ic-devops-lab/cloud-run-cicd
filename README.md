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

- Containerized version
```bash
docker compose up --build
```

---

## Infrastructure

### Overview

Terraform owns:
  - project
  - required APIs
  - Artifact Registry
  - Cloud Run service
  - Cloud Run runtime service account
  - IAM
  - later: Cloud SQL, VPC, Secret Manager, LB

Cloud Build owns:
  - build Docker image
  - push image
  - update Cloud Run service image

---

### Deploying the progect to GCP

1. Infrastructure Deployment
```bash
export PROJECT_ID="project-id"

cd infra/terraform

terraform init
terraform plan -var="project_id=${PROJECT_ID}"
terraform apply -var="project_id=${PROJECT_ID}" -auto-approve
```

2. Create the Cloud Build trigger manually in the console for speed:

Cloud Build → Triggers → Create trigger
- Source: GitHub
- Repo: ic-devops-lab/cloud-run-cicd
- Event: Push to branch
- Branch: ^main$
- Config file: cloudbuild.yaml
- Service account: select one created by terraform

3. Create and push commit in the project
```bash
git add .
git commit -m "Add Cloud Build deployment"
git push
```

---

## Sources

- https://docs.cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-python-fastapi-service

---
