variable "url" {
  type        = string
  description = "The URL of the identity provider."
}

variable "audiences" {
  type        = list(string)
  description = "A list of client IDs."
}

variable "thumbprints" {
  type        = list(string)
  default     = []
  description = "A list of server certificate thumbprints for the OIDC identity provider's server certificates."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources."
  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
