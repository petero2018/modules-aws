variable "peering_name" {
  type        = string
  description = "Name of the peering connection."
}

variable "accepter_vpc_id" {
  type        = string
  description = "VPC ID accepting the peering."
}

variable "requester_vpc_cidr" {
  type        = string
  description = "CIDR range of the accepting VPC."
}

variable "peering_connection_id" {
  type        = string
  description = "VPC peering connection ID from the requester side."
}

variable "side_tag" {
  type        = string
  default     = "Accepter"
  description = "Side tag value on peering."
}
