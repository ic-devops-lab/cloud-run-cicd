variable "project_id" {
  description = "The GCP project ID"
  type        = string
  # add to terraform.tfvars file, for ex.: project_id = "my-project-id-12345678"
}

variable "project_name" {
  description = "The GCP project name"
  type        = string
  # add to terraform.tfvars file, for ex.: project_name = "my-project-name-12345678"
}

# variable "project_folder" {
#   description = "The GCP project folder"
#   type        = string
#   # add to terraform.tfvars file, for ex.: project_folder = "my-project-folder-12345678"
# }

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "The name of the service"
  type        = string
  # add to terraform.tfvars file, for ex.: service_name = "my-service-name-12345678"
  default = "my-cloud-run-service"
}