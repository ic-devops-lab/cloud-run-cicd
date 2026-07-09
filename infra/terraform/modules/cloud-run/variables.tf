variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "cloud-run-service"
}

variable "cloudrun_image" {
  description = "The container image to deploy to Cloud Run"
  type        = string
}