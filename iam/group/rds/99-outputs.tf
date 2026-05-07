output "rds_read_arn" {
  value = {
    for k, group in aws_iam_group.rds_read : k => group.arn
  }
  description = "ARN of rds_read IAM group."
}

output "rds_read_id" {
  value = {
    for k, group in aws_iam_group.rds_read : k => group.id
  }
  description = "ID of rds_read IAM group."
}

output "rds_read_name" {
  value = {
    for k, group in aws_iam_group.rds_read : k => group.name
  }
  description = "Name of rds_read IAM group."
}

output "rds_write_arn" {
  value = {
    for k, group in aws_iam_group.rds_write : k => group.arn
  }
  description = "ARN of rds_write IAM group."
}

output "rds_write_id" {
  value = {
    for k, group in aws_iam_group.rds_write : k => group.id
  }
  description = "ID of rds_write IAM group."
}

output "rds_write_name" {
  value = {
    for k, group in aws_iam_group.rds_write : k => group.name
  }
  description = "Name of rds_write IAM group."
}
