output "replication_role_arn" {
  value       = aws_iam_role.replication.arn
  description = "IAM replication role ARN."
}
