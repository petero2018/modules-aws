output "guardrail_arn" {
  description = "The ARN of the guardrail"
  value       = aws_bedrock_guardrail.guardrail.guardrail_arn
}

output "guardrail_id" {
  description = "The ID of the guardrail"
  value       = aws_bedrock_guardrail.guardrail.guardrail_id
}

output "status" {
  description = "The status of the guardrail"
  value       = aws_bedrock_guardrail.guardrail.status
}

output "version" {
  description = "The current version of the guardrail"
  value       = aws_bedrock_guardrail.guardrail.version
}

output "published_versions" {
  description = "The published versions of the guardrail"
  value = [for version in aws_bedrock_guardrail_version.versions : {
    version     = version.version,
    description = version.description
    }
  ]
}
