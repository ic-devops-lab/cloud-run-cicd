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

## Using the project locally

- create dotenv file

In the project's root folder, uncomment and update variables if needed.
All commented settings are optional.

```bash
cp .env.sample .env
```

- From the code
> Requires Postgres service app
```bash
source .env
uvicorn $APP_MODULE --host $HOST --port $PORT --reload
```

- Containerized version
```bash
docker compose up
docker compose up --build
docker compose up postgres    # run only postgres service on container

docker compose down
docker compose down -v    # destoy volumes
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

#### What needs to be improved in IAM

Currently we create a single service account that does 2 different things:
1. builds and deploys the app in Cloud Build.
2. Starts Cloud Run service

Ideally it would be better to separate responsibilities:
```
Cloud Build SA
    ↓
Build
Push image
Deploy

Cloud Run Runtime SA
    ↓
Read Secret Manager
Connect to Cloud SQL
Call APIs
```

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
