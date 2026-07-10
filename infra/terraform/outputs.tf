output "service_url" {
  value = google_cloud_run_v2_service.app.uri
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}"
}

output "artifact_registry_repository" {
  value = google_artifact_registry_repository.artifact_repo.repository_id
}

output "runtime_service_account" {
  value = google_service_account.cloud_run_runtime.email
}