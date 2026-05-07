################################################################################
# OpenSearch Role Mapping
################################################################################

variable "role_name" {
  type = string

  description = "The name of the OpenSearch security role."
}

variable "backend_roles" {
  type = list(string)

  description = "A list of backend roles. Which are IAM Roles & Okta groups and users"
}
