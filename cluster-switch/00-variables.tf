variable "environment" {
  type = string

  description = "Cluster environment (\"dev\", \"staging\", \"prod\" or \"dr\")."

  validation {
    condition     = contains(["dev", "staging", "prod", "dr"], var.environment)
    error_message = "Illegal environment name."
  }
}

variable "switch_config" {
  type = map(object({
    blue = object({
      enabled = bool
      weight  = number
    })
    green = object({
      enabled = bool
      weight  = number
    })
  }))

  validation {
    condition = alltrue([
      for _, clusters in var.switch_config :
      clusters.blue.enabled || clusters.green.enabled
    ])
    error_message = "You can not disable both \"blue\" and \"green\" clusters."
  }

  validation {
    condition = alltrue([
      for _, clusters in var.switch_config :
      clusters.blue.weight + clusters.green.weight == 100
    ])
    error_message = "A sum of \"blue\" and \"green\" weights should be 100."
  }

  validation {
    condition = alltrue([
      for _, clusters in var.switch_config :
      (!clusters.blue.enabled && clusters.blue.weight == 0) || (clusters.blue.enabled)
    ])
    error_message = "Weight of disabled \"blue\" cluster should be zero."
  }

  validation {
    condition = alltrue([
      for _, clusters in var.switch_config :
      (!clusters.green.enabled && clusters.green.weight == 0) || (clusters.green.enabled)
    ])
    error_message = "Weight of disabled \"green\" cluster should be zero."
  }
  description = "Cluster traffic weight distribution config."
}
