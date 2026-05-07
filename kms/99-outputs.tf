output "key_arn" {
  value       = aws_kms_key.kms_key.arn
  description = "Key ARN."
}

output "key_id" {
  value       = aws_kms_key.kms_key.key_id
  description = "Key ID."
}

output "key_policy" {
  value       = aws_kms_key.kms_key.policy
  description = "The full policy associated with the key."
}

output "alias_arn" {
  value       = aws_kms_alias.key_alias.arn
  description = "Alias ARN."
}

output "alias_name" {
  value       = aws_kms_alias.key_alias.name
  description = "Alias name."
}
