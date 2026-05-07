output "arns" {
  value       = { for key, value in var.parameters : key => module.parameter[key].arn }
  description = "SSM parameter ARNs."
}
