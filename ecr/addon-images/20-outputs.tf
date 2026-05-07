output "image_repository" {
  value       = var.image_name != "" ? format("%s/%s", local.local_registry, var.image_name) : null
  description = "Local AWS Repository for the image"
}

output "local_registry" {
  value       = local.local_registry
  description = "Local AWS Registry"
}

output "registry_by_zone" {
  value       = local.amazon_container_image_registry_uris
  description = "All AWS Registry by region"
}
