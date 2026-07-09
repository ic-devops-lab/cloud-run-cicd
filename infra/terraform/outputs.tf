output "service_url" {
  value = google_cloud_run_v2_service.app.uri
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}"
}