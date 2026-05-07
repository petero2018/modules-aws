resource "aws_kms_key" "vpn_endpoint" {
  description             = "KMS key for ${var.name} VPN logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs to use the key"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "vpn_endpoint" {
  name              = "powise-vpn-${var.name}"
  retention_in_days = var.logs_retention
  kms_key_id        = aws_kms_key.vpn_endpoint.arn
  tags              = var.tags
}
