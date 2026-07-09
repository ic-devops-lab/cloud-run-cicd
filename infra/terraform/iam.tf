# Cloud Run deployment requires Cloud Run deploy permissions, Service Account User,
# and Artifact Registry image access. Google documents these role categories for
# Cloud Run image deployments.

locals {
  # cloudbuild_sa = "${google_project.gcp_project.number}@cloudbuild.gserviceaccount.com"
  cloudbuild_sa = "${data.google_project.gcp_project.number}-compute@developer.gserviceaccount.com"
}

resource "google_service_account" "cloud_run_runtime" {
  project      = var.project_id
  account_id   = "${var.service_name}-runtime"
  display_name = "Cloud Run runtime service account for ${var.service_name}"
}

resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}

resource "google_project_iam_member" "cloudrun_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}

resource "google_artifact_registry_repository_iam_member" "cloudbuild_artifact_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.artifact_repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${local.cloudbuild_sa}"
}

resource "google_artifact_registry_repository_iam_member" "cloudrun_artifact_reader" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.artifact_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
}