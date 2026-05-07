################################################################################
# OpenSearch Cluster Configuration
################################################################################

variable "endpoint" {
  type = string

  description = "OpenSearch endpoint to send the requests."
}

################################################################################
# OpenSearch Request
################################################################################

variable "method" {
  type = string

  default     = "PUT"
  description = "HTTP Method to send to OpenSearch."
}

variable "path" {
  type = string

  description = "HTTP Path to send to OpenSearch."
}

variable "body" {
  type = map(any)

  description = "Body to send to OpenSearch."
}
