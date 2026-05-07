locals {
  endpoint        = coalesce(var.custom_endpoint, aws_opensearch_domain.es.endpoint)
  kibana_endpoint = "${local.endpoint}/_plugin/kibana/"
  url             = "https://${local.endpoint}"
  kibana_url      = "https://${local.kibana_endpoint}"
}

output "arn" {
  value       = aws_opensearch_domain.es.arn
  description = "ARN of the domain."
}

output "domain" {
  value       = aws_opensearch_domain.es.domain_name
  description = "Name of the OpenSearch domain."
}

output "version" {
  value       = aws_opensearch_domain.es.engine_version
  description = "Engine Version of the OpenSeach domain."
}

output "endpoint" {
  value       = local.endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
}

output "kibana_endpoint" {
  value       = local.kibana_endpoint
  description = "Domain-specific endpoint for kibana without https scheme."
}

output "url" {
  value       = local.url
  description = "Domain-specific url used to submit index, search, and data upload requests."
}

output "kibana_url" {
  value       = local.kibana_url
  description = "Domain-specific url for kibana without https scheme."
}

output "iam_readonly_policy_arn" {
  description = "ARN of the IAM read only policy for this domain."
  value       = module.readonly_policy.arn
}
