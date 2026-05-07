variable "vpc_name" {
  description = "Name of VPC to create the securty group in"
  type        = string
}

variable "default_tags" {
  default = {
    team    = "product-infrastructure"
    impact  = "critical"
    service = "bastion"
  }
  description = "Default Tags for Security Group"
  type        = map(string)
}


variable "tags" {
  description = "Default Tags for Security Group"
  type        = map(string)
}
