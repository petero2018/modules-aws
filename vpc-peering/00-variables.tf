variable "peering_name" {
  type        = string
  description = "Name of the peering connection."
}

variable "requester_vpc_id" {
  type        = string
  description = "VPC ID creating the peering."
}

variable "accepter_vpc_id" {
  type        = string
  description = "VPC ID accepting the peering."
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow accepter VPC to resolve DNS in requester VPC."
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve DNS in accepter VPC."
}

variable "side_tag" {
  type        = string
  default     = "Both"
  description = "Side tag value on peering."
}
