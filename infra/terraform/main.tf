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

# resource "google_project" "gcp_project" {
#   name       = var.project_name
#   project_id = var.project_id
#   # folder_id  = google_folder.project_folder.name
# }

data "google_project" "gcp_project" {
  project_id = var.project_id
}