resource "aws_athena_workgroup" "workgroup" {
  count = var.enable_athena ? 1 : 0

  name = local.inventory_name
  configuration {
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${module.inventory_bucket.bucket_id}/athena_output/"
    }
  }
  tags = var.tags
}
