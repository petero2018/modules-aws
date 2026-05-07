data "aws_caller_identity" "this" {}
data "aws_iam_session_context" "this" {
  arn = data.aws_caller_identity.this.arn
}
data "aws_region" "current" {}

locals {
  body = jsonencode(var.body)
}

resource "null_resource" "request" {
  triggers = {
    method = var.method
    path   = var.path
    body   = local.body
  }

  provisioner "local-exec" {
    environment = {
      OS_ENDPOINT = var.endpoint
      AWS_ROLE    = data.aws_iam_session_context.this.issuer_arn
      AWS_REGION  = data.aws_region.current.name
      HTTP_METHOD = var.method
      HTTP_PATH   = var.path
      HTTP_BODY   = local.body
    }
    command     = format("%s/scripts/request.sh", path.module)
    interpreter = ["bash", "-c"]
  }
}
