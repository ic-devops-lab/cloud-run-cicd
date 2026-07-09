resource "google_project_service" "container_registry_api" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

resource "null_resource" "docker_build_push" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = "${path.root}/../../src/app"

    command = <<-EOT
      # Build the Docker image
      docker build -f Dockerfile -t gcr.io/${var.project_id}/${var.image_name}:latest .

      # Configure docker to authenticate with GCP
      gcloud auth configure-docker --quiet

      # Push the image
      docker push gcr.io/${var.project_id}/${var.image_name}:latest
    EOT
  }

  depends_on = [
    google_project_service.container_registry_api
  ]
}