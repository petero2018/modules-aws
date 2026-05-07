output "vault_id" {
  description = "ID associated with the AWS Backup Vault."
  value       = aws_backup_vault.vault.id
}

output "vault_arn" {
  description = "ARN associated with the AWS Backup Vault."
  value       = aws_backup_vault.vault.arn
}
