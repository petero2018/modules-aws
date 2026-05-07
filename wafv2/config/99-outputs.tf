output "rule_group_arn" {
  value       = aws_wafv2_rule_group.ip_lists.arn
  description = "ARN of rule group to be attached to every WAF."
}

output "rule_group_v2_arn" {
  value       = aws_wafv2_rule_group.ip_lists_v2.arn
  description = "ARN of rule group to be attached to every WAF."
}

######################################################################
# Allowed IP Set ARNs
######################################################################

output "static_allowed_ipset_arn_ipv4" {
  value       = aws_wafv2_ip_set.static_allowed_ips["IPV4"].arn
  description = "ARNs of the allowlist IP sets (IPv4)."
}

output "static_allowed_ipset_arn_ipv6" {
  value       = aws_wafv2_ip_set.static_allowed_ips["IPV6"].arn
  description = "ARNs of the allowlist IP sets (IPv6)."
}

output "dynamic_allowed_ipset_arn_ipv4" {
  value       = aws_wafv2_ip_set.dynamic_allowed_ips["IPV4"].arn
  description = "ARNs of the allowlist IP sets (IPv4)."
}

output "dynamic_allowed_ipset_arn_ipv6" {
  value       = aws_wafv2_ip_set.dynamic_allowed_ips["IPV6"].arn
  description = "ARNs of the allowlist IP sets (IPv6)."
}

######################################################################
# Blocked IP Set ARNs
######################################################################

output "static_blocked_ipset_arn_ipv4" {
  value       = aws_wafv2_ip_set.static_blocked_ips["IPV4"].arn
  description = "ARNs of the static blocklist IP sets (IPv4)."
}

output "static_blocked_ipset_arn_ipv6" {
  value       = aws_wafv2_ip_set.static_blocked_ips["IPV6"].arn
  description = "ARNs of the static blocklist IP sets (IPv6)."
}

output "dynamic_blocked_ipset_arn_ipv4" {
  value       = aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].arn
  description = "ARNs of the dynamic blocklist IP sets (IPv4)."
}

output "dynamic_blocked_ipset_arn_ipv6" {
  value       = aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].arn
  description = "ARNs of the dynamic blocklist IP sets (IPv6)."
}
