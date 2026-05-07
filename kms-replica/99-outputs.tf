output "key_arn" {
  value       = aws_kms_replica_key.replica.arn
  description = "Key ARN."
}

output "key_id" {
  value       = aws_kms_replica_key.replica.key_id
  description = "Key ID."
}
