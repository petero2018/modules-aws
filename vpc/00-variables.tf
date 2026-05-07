################################################################################
# VPC
################################################################################

variable "vpc_name" {
  type        = string
  description = "Name of the VPC."
}

variable "cidr_block" {
  type        = string
  description = "CIDR Range of the network."
}

variable "subnets" {
  type = map(object({
    az                = string,
    is_public         = bool,
    extra_tags        = optional(map(string)),
    use_for_endpoints = optional(bool, false), # Only one subnet per AZ can have this enabled
  }))
  description = "Map of subnets to create. Key is the CIDR range of the subnet."
}

variable "single_public_route_table" {
  type        = bool
  description = "Use a single route table for public subnets instead of one per subnet."
  default     = false
}

################################################################################
# Service Endpoints
################################################################################

variable "enable_service_gateways" {
  type = bool

  default     = true
  description = "Enable S3 and DynamoDB gateways on the VPC."
}

variable "aws_service_endpoints" {
  type = map(string)

  default     = {}
  description = "AWS Services to create vpc endpoints."
}

variable "enable_datadog_endpoints" {
  type = bool

  default     = false
  description = "Enable Datadog private endpoints, only valid in us-east-1."
}

################################################################################
# Wazuh
################################################################################

variable "enable_wazuh_endpoint" {
  type        = bool
  description = "Create an endpoint for wazuh agents to communicate with the manager in the security account."
  default     = true
}

variable "wazuh_endpoint_service_name" {
  type        = string
  description = "The endpoint service name to be used for the VPC endpoint."
  default     = null
}

################################################################################
# Flow Logs
################################################################################

variable "enable_flow_logs" {
  type        = bool
  description = "Capture VPC flow traffic."
  default     = false
}

variable "destination_options" {
  type = object({
    file_format                = string
    hive_compatible_partitions = bool
    per_hour_partition         = bool
  })
  description = "Destination options for a flow log."
  default = {
    file_format                = "plain-text"
    hive_compatible_partitions = false
    per_hour_partition         = true
  }
}

variable "log_format" {
  type        = string
  description = "Field formatting for VPC flow logs."
  default     = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${pkt-srcaddr} $${pkt-dstaddr} $${type} $${region} $${az-id} $${sublocation-type} $${sublocation-id} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
}

################################################################################
# Tags
################################################################################

variable "vpc_tags" {
  type        = map(string)
  description = "Extra tags to be applied to the VPC resource."
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Extra tags to be applied to public subnets."
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Extra tags to be applied to private subnets."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to AWS resources."

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

variable "create_vpc_policy" {
  type        = bool
  description = "Create a policy to restrict access to the VPC CIDR."
  default     = false
}

variable "policy_path" {
  type        = string
  description = "The path of the policy in IAM."
  default     = "/"
}

variable "vpc_source_ips" {
  type        = list(string)
  description = "Source IP addresses to restrict access to the VPC."
  default     = []
}
