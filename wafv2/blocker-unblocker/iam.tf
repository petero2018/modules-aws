resource "aws_iam_role" "waf_lambda_role" {
  name               = "WAF-LambdaRole"
  description        = "Role that Lambda can assume to update the WAF IP Set"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }
}

resource "aws_iam_policy" "waf_lambda_policy" {
  name        = "waf-lambda-policy"
  description = "Policy granting Lambda permissions to update the WAF IPSet"
  policy      = data.aws_iam_policy_document.lambda_policy.json
  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }
}

resource "aws_iam_role_policy_attachment" "waf_lambda_policy" {
  role       = aws_iam_role.waf_lambda_role.name
  policy_arn = aws_iam_policy.waf_lambda_policy.arn
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {

    actions = [
      "wafv2:GetIPSet",
      "wafv2:UpdateIPSet",
    ]

    effect = "Allow"

    resources = concat(
      var.allow_ipset_arns_ipv4,
      var.allow_ipset_arns_ipv6,
      var.block_ipset_arns_ipv4,
      var.block_ipset_arns_ipv6
    )
  }

  statement {

    actions = [
      "dynamodb:PutItem",
      "dynamodb:Query",
    ]

    effect = "Allow"

    resources = [
      aws_dynamodb_table.waf_blocks.arn,
      "${aws_dynamodb_table.waf_blocks.arn}/index/${local.waf_blocks_gsi_name}"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:GetItem"
    ]

    effect = "Allow"

    resources = [
      aws_dynamodb_table.waf_blocks_whitelist.arn,
      "${aws_dynamodb_table.waf_blocks_whitelist.arn}/index/${local.waf_blocks_whitelist_gsi_name}"
    ]

  }

  statement {
    actions = ["logs:CreateLogGroup"]

    effect = "Allow"

    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_blocker.function_name}:*",
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_updater.function_name}:*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_blocker.function_name}:*",
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_updater.function_name}:*",
    ]
  }

  statement {
    # This is to prevent unauthorized lambdas from using WAF-LambdaRole. Any Lambda will be able to assume it, but only the two from this module will be able to use it.
    # Adding conditions to the role's trust relationship like aws:SourceArn or lambda:FunctionArn were not behaving as expected
    # Statement taken from https://stackoverflow.com/questions/42717431/iam-role-limit-stsassumerole-to-one-aws-lambda-function
    sid     = "WhitelistSpecificLambdaFunction"
    actions = ["*"]

    effect = "Deny"

    resources = ["*"]

    condition {
      test     = "StringNotLike"
      variable = "aws:userid"

      values = [
        "*:${aws_lambda_function.waf_blocker.function_name}",
        "*:${aws_lambda_function.waf_updater.function_name}",
      ]
    }
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = ["SNS:Publish"]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/SecurityAuditToolsRole"]
    }

    resources = [
      aws_sns_topic.waf_ips.arn,
    ]
  }
}

data "aws_iam_policy_document" "sns_key_policy" {
  #checkov:skip=CKV_AWS_109: KMS usage is restricted to a single role
  #checkov:skip=CKV_AWS_111: KMS usage is restricted by condition even though Principal is an asterisk
  #checkov:skip=CKV_AWS_356: This is a resource policy - "*" only refers to the key itself
  statement {
    sid = "Allow Security to read notifications of the SNS topic that is attached to this key"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::289042178966:role/LogstashRole",
        "arn:aws:iam::${var.aws_account_id}:role/SecurityAuditToolsRole",
      ]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }

  statement {
    sid = "Allow Terraform to update this key in the future"

    actions = ["kms:*"]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/TerraformRole"]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }

  statement {
    sid = "Allow Admins to see the key, but not modify it from the console"

    actions = [
      "kms:Describe*",
      "kms:List*",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/AdminRole"]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }

  statement {
    sid = "Allow admins to use the key to publish messages"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/AdminRole"]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }
}
