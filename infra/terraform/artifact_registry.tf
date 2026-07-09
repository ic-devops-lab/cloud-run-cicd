resource "google_artifact_registry_repository" "artifact_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_repo
  format        = "DOCKER"

  depends_on = [
    google_project_service.required
  ]
}