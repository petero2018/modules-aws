resource "aws_lambda_function" "content_moderation" {
  #checkov:skip=CKV_AWS_173:Environment variables are not secrets
  #checkov:skip=CKV_AWS_116:No need for a Dead Letter Queue, backups can be re-triggered any time manually
  #checkov:skip=CKV_AWS_117:We don't really care about running this function in a specific VPC
  #checkov:skip=CKV_AWS_272:Disable validate code-signing check

  filename      = "lambda.zip"
  function_name = local.lambda_function_name
  description   = "Sends items to AWS Rekognition for content moderation"
  role          = aws_iam_role.role.arn
  handler       = "contentModeration.handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs20.x"

  reserved_concurrent_executions = 10

  environment {
    variables = {
      "UPLOAD_BUCKET" = var.upload_bucket
    }
  }

  tracing_config {
    mode = "PassThrough"
  }

  tags = local.tags
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "lambda.zip"
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.content_moderation.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.upload_bucket}"
}


resource "aws_s3_bucket_notification" "upload_notification" {
  bucket = var.upload_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.content_moderation.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
