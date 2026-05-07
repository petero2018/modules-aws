output "ipset_ipv4_regional_arn" {
  description = "The ARN of the ipset containing known search engines' IPv4 addresses."
  value       = try(aws_wafv2_ip_set.search_engines_ipv4_regional[0].arn, null)
}

output "ipset_ipv6_regional_arn" {
  description = "The ARN of the ipset containing known search engines' IPv6 addresses."
  value       = try(aws_wafv2_ip_set.search_engines_ipv6_regional[0].arn, null)
}

output "ipset_ipv4_cloudfront_arn" {
  description = "The ARN of the Cloudfront ipset containing known search engines' IPv4 addresses."
  value       = try(aws_wafv2_ip_set.search_engines_ipv4_cloudfront[0].arn, null)
}

output "ipset_ipv6_cloudfront_arn" {
  description = "The ARN of the Cloudfront ipset containing known search engines' IPv6 addresses."
  value       = try(aws_wafv2_ip_set.search_engines_ipv6_cloudfront[0].arn, null)
}
