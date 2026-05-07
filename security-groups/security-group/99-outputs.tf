output "security_group_id" {
  value = aws_security_group.allow_ingress.id

  description = "ID for the security group."
}

output "security_group_arn" {
  value = aws_security_group.allow_ingress.arn

  description = "ARN for the security group."
}
