output "arn" {
  value       = var.dynamic ? aws_ssm_parameter.parameter_dynamic[0].arn : aws_ssm_parameter.parameter[0].arn
  description = "SSM parameter ARN."
}
