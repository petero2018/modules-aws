output "stream_arns" {
  description = "ARNs of the created streams."
  value       = { for k, stream in aws_kinesis_stream.streams : k => stream.arn }
}
