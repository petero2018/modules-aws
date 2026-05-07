resource "aws_scheduler_schedule" "monitoring_lambda" {
  # Add schedule for the monitoring Lambda function

  #checkov:skip=CKV_AWS_297:We don't need a CMK for this

  count = try(var.monitoring_lambda.enabled, false) ? 1 : 0

  name = "rds-monitoring-lambda-${var.name}"

  # A group is optional but nice to keep things organized
  group_name = var.monitoring_lambda.scheduler_group_name

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(1 minutes)"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:lambda:invoke" # Fixed value for all Lambdas
    role_arn = var.monitoring_lambda.scheduler_iam_role_arn

    input = jsonencode({
      FunctionName   = var.monitoring_lambda.monitoring_lambda_arn
      InvocationType = "Event"
      Payload = jsonencode(merge(
        {
          rds_name = var.name
          type     = var.engine
          host     = aws_db_instance.primary.address
        },
        var.enable_proxy ? {
          proxy_host = aws_db_proxy.proxy[0].endpoint
          proxy_user = aws_db_instance.primary.username # To connect via RDS Proxy we use the regular database user name to generate the IAM token
      } : {}))
    })
  }
}
