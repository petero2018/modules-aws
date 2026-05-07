output "id" {
  description = "Name of the table."
  value       = aws_dynamodb_table.table.id
}

output "arn" {
  description = "ARN of the table."
  value       = aws_dynamodb_table.table.arn
}

output "iam_readwrite_policy_arn" {
  description = "ARN of the IAM read/write policy for this table, if created."
  value       = var.create_iam_readwrite_policy ? module.readwrite_policy[0].arn : null
}
