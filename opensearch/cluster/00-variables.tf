################################################################################
# OpenSearch Cluster Configuration
################################################################################

variable "domain" {
  type = string

  description = "Name of the domain."
}

variable "engine" {
  type = string

  default     = "Elasticsearch"
  description = "Engine to use in this cluster. Available options: OpenSearch or Elasticsearch"

  validation {
    condition     = contains(["OpenSearch", "Elasticsearch"], var.engine)
    error_message = "Valid engine required: OpenSearch, Elasticsearch."
  }
}

variable "es_version" {
  type = string

  default     = "7.10"
  description = "Version of Elasticsearch to deploy."
}

variable "instance_count" {
  type = number

  default     = 3
  description = "Number of instances in the cluster."
}

variable "instance_type" {
  type = string

  default     = "i3.xlarge"
  description = "Instance type of data nodes in the cluster."
}

variable "max_clause_count" {
  type = number

  default     = 1024
  description = "Specifies the maximum number of clauses allowed in a query."
}

################################################################################
# Elasticsearch Master Nodes
################################################################################

variable "dedicated_master_count" {
  type = number

  default     = 0
  description = "Number of dedicated main nodes in the cluster. if 0, then will disable master nodes."
}

variable "dedicated_master_type" {
  type = string

  default     = "m5.large"
  description = "Instance type of the dedicated main nodes in the cluster."
}

################################################################################
# Elasticsearch EBS Config
################################################################################

variable "ebs_enabled" {
  type = bool

  default     = false
  description = "Whether EBS volumes are attached to data nodes in the domain."
}

variable "ebs_volume_type" {
  type = string

  default     = "gp3"
  description = "Type of EBS volumes attached to data nodes."
}

variable "ebs_volume_size" {
  type = string

  default     = "1024"
  description = "Size of EBS volumes attached to data nodes (in GiB)."
}

variable "ebs_iops" {
  type = number

  default     = null
  description = "Volume IOPS (for gp3 and provisioned IOPS only)."
}

variable "ebs_throughput" {
  type = number

  default     = null
  description = "Volume throughput in MiB/s (for gp3 and provisioned IOPS only, always optional)."
}

################################################################################
# Networking
################################################################################

variable "vpc_id" {
  type = string

  default     = null
  description = "VPC where to deploy the elasticsearch cluster."
}

variable "vpc_name" {
  type = string

  default     = null
  description = "VPC name where to deploy the elasticsearch cluster."
}

variable "subnet_ids" {
  type = list(string)

  default     = null
  description = "List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in. Will use subnet tags if not defined"
}

variable "subnet_tags" {
  type = map(string)

  default     = { tier = "private" }
  description = "Tags to lookup subnets for the Elasticsearch domain endpoints to be created in."
}

variable "zone_awareness" {
  type = bool

  default     = true
  description = "Whether zone awareness is enabled, set to true for multi-az deployment."
}

variable "availability_zone_count" {
  type = number

  default     = 3
  description = "Number of Availability Zones for the domain to use with zone_awareness_enabled."
}

################################################################################
# Security Groups
################################################################################

variable "enable_access_from_vpc" {
  type = list(string)

  default     = []
  description = "List of VPC IDs to enable access from. VPC peering is not setup here."
}

variable "enable_access_from_cidrs" {
  type = list(string)

  default     = []
  description = "List of CIDRs allowed to access from."
}

################################################################################
# Log
################################################################################

variable "logs_enabled" {
  type = bool

  default     = true
  description = "Enables sending logs to CW logs for troubleshooting."
}

variable "log_group_name" {
  type = string

  default     = null
  description = "CW Log group where the Elasticsearch cluster will send the logs."
}

variable "log_retention_days" {
  type = number

  default     = 90
  description = "CW logs retention days."
}

variable "log_types" {
  type = list(string)

  default = [
    "INDEX_SLOW_LOGS",
    "SEARCH_SLOW_LOGS",
    "ES_APPLICATION_LOGS",
    "AUDIT_LOGS"
  ]
  description = "List of elasticsearch logs to send to CW logs."
}

################################################################################
# IAM Setup
################################################################################

variable "create_iam_service_linked_role_count" {
  type = bool

  default     = true
  description = "Creates an IAM Service Linked role for this cluster."
}

################################################################################
# Access Policies
################################################################################

variable "dashboard_users_cidrs" {
  type = list(string)

  description = "CIDR of the dashboard users. This should be the VPN CIDR."
}

################################################################################
# Custom Endpoint
################################################################################

variable "custom_endpoint_enabled" {
  type = bool

  default     = false
  description = "Enables Custom Endpoint URL"
}

variable "custom_endpoint_certificate_arn" {
  type = string

  default     = null
  description = "ACM certificate ARN for your custom endpoint."
}

variable "custom_endpoint_zone" {
  type = string

  default     = null
  description = "Zone where the custom endpoint will be created."
}

variable "custom_endpoint" {
  type = string

  default     = null
  description = "Fully qualified domain for your custom endpoint."
}

################################################################################
# SAML
################################################################################

variable "saml_enable" {
  type = bool

  default     = false
  description = "Enables SAML authentication for Kibana"
}

variable "saml_metadata_xml" {
  type = string

  default     = null
  description = "SSM Parameter where to get the SAML metadata xml"
}

variable "saml_idp_entity_id" {
  type = string

  default     = null
  description = "Unique Entity ID of the application in SAML Identity Provider."
}

variable "saml_roles_key" {
  type = string

  default     = "Group"
  description = "Element of the SAML assertion to use for backend roles."
}

variable "saml_master_backend_role" {
  type = string

  default     = "admins"
  description = "This backend role from the SAML IdP receives full permissions to the cluster, equivalent to a new master user."
}

variable "saml_session_timeout_minutes" {
  type = number

  default     = 1440 # 24 hours
  description = "Duration of SAML sessions."
}

################################################################################
# Auto tune & updates
################################################################################

variable "off_peak_window_enabled" {
  type        = bool
  default     = false
  description = "Enable off-peak window for updates."
}

variable "off_peak_window_hours" {
  type        = number
  default     = 20
  description = "Hour start of the 10 hours off-peak window (UTC)."
}

variable "off_peak_window_minutes" {
  type        = number
  default     = 0
  description = "Minutes start of the 10 hours off-peak window."
}

variable "auto_software_update_enabled" {
  type        = bool
  default     = false
  description = "Enable automated service software updates."
}

variable "auto_tune_enabled" {
  type        = bool
  default     = false
  description = "Enable auto-tune."
}

################################################################################
# UltraWarm nodes configuration
################################################################################

variable "warm_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable UltraWarm nodes."
}

variable "warm_count" {
  type        = number
  default     = null
  description = "Count of UltraWarm nodes."
}

variable "warm_type" {
  type        = string
  default     = null
  description = "Type of UltraWarm instances."
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "Tags to be applied to AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
