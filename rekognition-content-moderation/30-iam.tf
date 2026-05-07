# Data sources
data "aws_iam_policy_document" "allow_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.project_name}-${var.environment}-${data.aws_region.current.name}"

  assume_role_policy = data.aws_iam_policy_document.allow_lambda.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "IAM policy for Lambda to interact with S3 and CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.upload_bucket}",
          "arn:aws:s3:::${var.upload_bucket}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject*",
          "s3:ListBucket",
          "s3:GetObject*",
          "s3:DeleteObject*",
          "s3:GetBucketLocation"
        ],
        Resource = [
          module.bucket.bucket_arn,
          "${module.bucket.bucket_arn}/*"
        ]
      }
    ]
  })

  tags = local.tags
}
