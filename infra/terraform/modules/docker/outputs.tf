output "image" {
  description = "Full image tag."
  value = "gcr.io/${var.project_id}/${var.image_name}:latest"
}