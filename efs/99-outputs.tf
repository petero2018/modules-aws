output "efs_dns_name" {
  description = "The DNS name of the EFS file system."
  value       = aws_efs_file_system.efs.dns_name
}
