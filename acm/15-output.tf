output "id" {
  description = "ID associated with the generated certificate."
  value       = aws_acm_certificate.this.id
}

output "arn" {
  description = "ARN associated with the generated certificate."
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Domain name associated with the generated certificate."
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "The resource records required for ACM DNS validation"
  value       = aws_acm_certificate.this.domain_validation_options
}
