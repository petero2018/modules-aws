resource "aws_flow_log" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination_type = "s3"
  log_destination      = "arn:aws:s3:::powise-vpc-flow-logs-${data.aws_region.current.name}" # Regional bucket in logs account
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  destination_options {
    file_format                = var.destination_options.file_format
    hive_compatible_partitions = var.destination_options.hive_compatible_partitions
    per_hour_partition         = var.destination_options.per_hour_partition
  }

  log_format = var.log_format
  tags       = var.tags
}
