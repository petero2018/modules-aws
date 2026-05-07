output "security_group_ids" {
  value       = [for sg in aws_security_group.cloudfront_sg : sg.id]
  description = "IDs for the security groups."
}

output "security_group_arns" {
  value       = [for sg in aws_security_group.cloudfront_sg : sg.arn]
  description = "ARNs for the security groups."
}
