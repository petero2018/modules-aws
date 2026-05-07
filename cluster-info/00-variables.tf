variable "environment" {
  type = string

  description = "Cluster environment (\"dev\", \"prod\" or \"dr\")."

  validation {
    condition     = contains(["dev", "prod", "dr"], var.environment)
    error_message = "Illegal environment name."
  }
}
