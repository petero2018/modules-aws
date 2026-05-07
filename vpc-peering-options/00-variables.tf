variable "side" {
  type        = string
  description = "Side of the VPC peering, can be 'requester', 'accepter' or 'both'."

  validation {
    condition     = contains(["requester", "accepter", "both"], var.side)
    error_message = "The side can only be 'requester', 'accepter' or 'both'."
  }
}

variable "vpc_peering_id" {
  type        = string
  description = "VPC peering ID. The peering must already exist and be accepted."
}

variable "allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "ALlow remote VPC DNS resolution."
}
