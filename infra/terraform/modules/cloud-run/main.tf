resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "containerregistry.googleapis.com"
  ])

  project = var.project_id
  service = each.key
}


resource "google_cloud_run_service" "default" {
  name = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.cloudrun_image
      }
    }
  }

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_service.default.location
  project  = var.project_id
  service  = google_cloud_run_service.default.name
  role   = "roles/run.invoker"
  member = "allUsers"
}