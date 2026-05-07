output "arn" {
  value       = aws_iam_user.user.arn
  description = "IAM user ARN."
}

output "name" {
  value       = aws_iam_user.user.name
  description = "IAM user name."
}

output "access_key_id" {
  value       = aws_iam_access_key.access_key.id
  description = "IAM user access key ID."
}
