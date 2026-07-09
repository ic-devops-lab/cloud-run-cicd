locals {
  image_name = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}/${var.service_name}:latest"
}

resource "google_cloud_run_v2_service" "app" {
  project  = var.project_id
  location = var.region
  name     = var.service_name

  ingress = "INGRESS_TRAFFIC_ALL" # Allow all traffic to the service

  template {
    service_account = google_service_account.cloud_run_runtime.email

    containers {
      # image = local.image_name  # use only after the first deployment, when the image is built and pushed to Artifact Registry. Otherwise, use the initial image to create the service.
      image = var.initial_image

      ports {
        container_port = 8080
      }
      env {
        name  = "APP_ENV"
        value = "dev"
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }
  }

  depends_on = [
    google_project_service.required,
    google_artifact_registry_repository.artifact_repo,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = google_cloud_run_v2_service.app.location
  name     = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}