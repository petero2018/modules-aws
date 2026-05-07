output "arn" {
  value       = aws_iam_role.role.arn
  description = "Role ARN."
}

output "name" {
  value       = aws_iam_role.role.name
  description = "Role name."
}
