variable "peering_name" {
  type        = string
  description = "Name of the peering connection."
}

variable "requester_vpc_id" {
  type        = string
  description = "VPC ID requesting the peering."
}

variable "accepter_vpc_id" {
  type        = string
  description = "VPC ID accepting the peering."
}

variable "accepter_vpc_cidr" {
  type        = string
  description = "CIDR range of the accepting VPC."
}

variable "accepter_owner_id" {
  type = string

  default     = null
  description = "Owner ID of the accepting VPC. Leave empty to for peerings in the same account."
}

variable "accepter_region" {
  type = string

  default     = null
  description = "Accepter region. Leave empty for peerings in the same region."
}

variable "side_tag" {
  type        = string
  default     = "Requester"
  description = "Side tag value on peering."
}
