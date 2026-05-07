module "ips" {
  source = "git@github.com:powise/terraform-modules//common/ips?ref=ips-0.2.7"
}

resource "aws_wafv2_ip_set" "dynamic_allowed_ips" {
  for_each = toset(local.ip_versions)

  addresses          = []
  description        = "Dynamic Allowed List - Exception for Specific ${each.value} IPs"
  ip_address_version = each.value
  name               = "Dynamic_${each.value}_Allowed_IPs"
  scope              = var.scope

  tags = var.tags

  lifecycle {
    ignore_changes        = [addresses] # List of blocked IP addresses is automatically updated outside of Terraform
    create_before_destroy = true        # Terraform otherwise errors out trying to destroy the IP set before it is detached from the ACL
  }
}

resource "aws_wafv2_ip_set" "static_allowed_ips" {
  for_each = toset(local.ip_versions)

  addresses          = each.value == "IPV4" ? concat(module.ips.vpn_nat_gw_ips, var.allowed_ips.ipv4) : var.allowed_ips.ipv6
  description        = "Static Allowed List - Exception for Specific ${each.value} IPs"
  ip_address_version = each.value
  name               = "Static_${each.value}_Allowed_IPs"
  scope              = var.scope

  tags = var.tags

  lifecycle {
    create_before_destroy = true # Terraform otherwise errors out trying to destroy the IP set before it is detached from the ACL
  }
}

resource "aws_wafv2_ip_set" "dynamic_blocked_ips" {
  for_each = toset(local.ip_versions)

  description        = "Dynamic Block List - Exception for Specific ${each.value} IPs"
  addresses          = []
  ip_address_version = each.value
  name               = "Dynamic_${each.value}_Blocked_IPs"
  scope              = var.scope

  tags = var.tags

  lifecycle {
    ignore_changes        = [addresses] # List of blocked IP addresses is automatically updated outside of Terraform
    create_before_destroy = true        # Terraform otherwise errors out trying to destroy the IP set before it is detached from the ACL
  }
}

resource "aws_wafv2_ip_set" "static_blocked_ips" {
  for_each = toset(local.ip_versions)

  description        = "Static Block List - Exception for Specific ${each.value} IPs"
  addresses          = each.value == "IPV4" ? var.blocked_ips.ipv4 : var.blocked_ips.ipv6
  ip_address_version = each.value
  name               = "Static_${each.value}_Blocked_IPs"
  scope              = var.scope

  tags = var.tags

  lifecycle {
    create_before_destroy = true # Terraform otherwise errors out trying to destroy the IP set before it is detached from the ACL
  }
}

moved {
  from = aws_wafv2_ip_set.allowed_ips
  to   = aws_wafv2_ip_set.static_allowed_ips
}
