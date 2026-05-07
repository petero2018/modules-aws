resource "aws_lambda_invocation" "iam_auth_hook" {
  count = var.prepare_deletion ? 0 : 1 # Never try to trigger this hook when we're preparing for deletion (database won't be reachable)

  function_name = var.iam_auth_lambda_function_name

  input = jsonencode(
    {
      rds_name         = var.name
      has_read_replica = length(var.replica_configurations) > 0 ? true : false
      setup_fivetran   = var.fivetran.enabled
      main_schema      = var.fivetran.main_schema
      main_database    = var.fivetran.main_database
    }
  )

  depends_on = [aws_ssm_parameter.master] # SSM parameter must exist as the Lambda reads it
}

moved { # Added count argument
  from = aws_lambda_invocation.iam_auth_hook
  to   = aws_lambda_invocation.iam_auth_hook[0]
}
