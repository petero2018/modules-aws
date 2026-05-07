output "health_check_ids" {
  value       = [for hc in aws_route53_health_check.example : hc.id]
  description = "The id of the health check."
}

output "health_check_arns" {
  value       = [for hc in aws_route53_health_check.example : hc.arn]
  description = "The Amazon Resource Name (ARN) of the Health Check."
}

output "aggregated_health_check_id" {
  value       = try(aws_route53_health_check.aggregated[0].id, null)
  description = "The ID of the aggregated health check."
}

output "aggregated_health_check_arn" {
  value       = try(aws_route53_health_check.aggregated[0].arn, null)
  description = "The Amazon Resource Name (ARN) of the aggregated health check."
}
