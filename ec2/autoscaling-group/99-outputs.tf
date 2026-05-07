output "asg_arn" {
  value       = aws_autoscaling_group.group.arn
  description = "The ARN of the autoscaling group"
}

output "asg_name" {
  value       = aws_autoscaling_group.group.name
  description = "The name of the autoscaling group"
}
