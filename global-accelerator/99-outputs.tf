output "global_accelerator_arn" {
  value = aws_globalaccelerator_accelerator.accelerator.id

  description = "ARN of the Global Accelerator."
}

output "listener_arn" {
  value = aws_globalaccelerator_listener.listener.id

  description = "ARN of the Global Accelerator Listener."
}
