terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# resource "google_folder" "project_folder" {
#   display_name = var.project_folder
#   parent = null
# }

resource "google_project" "gcp_project" {
  name       = var.project_name
  project_id = var.project_id
  # folder_id  = google_folder.project_folder.name
}

module "docker" {
  source = "./modules/docker"

  project_id = var.project_id
  image_name = var.service_name
}

module "cloud_run_service" {
  source = "./modules/cloud-run"

  project_id     = var.project_id
  region         = var.region
  service_name   = var.service_name
  cloudrun_image = module.docker.image

  depends_on = [
    module.docker
  ]
}