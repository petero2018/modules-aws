data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "waf_lambda_role_search_engines" {
  name               = "WAF-LambdaRole-Search-Engines${local.name_suffix}"
  description        = "Role that Lambda can assume to update the WAF IP Set"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_search_engines.json
  tags               = local.tags
}

resource "aws_iam_policy" "waf_lambda_policy_search_engines" {
  name        = "waf-lambda-policy-search-engines${local.name_suffix}"
  description = "Policy granting Lambda permissions to update the WAF IPSet"
  policy      = data.aws_iam_policy_document.lambda_policy_search_engines.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "waf_lambda_policy_search_engines" {
  role       = aws_iam_role.waf_lambda_role_search_engines.name
  policy_arn = aws_iam_policy.waf_lambda_policy_search_engines.arn
}

data "aws_iam_policy_document" "lambda_assume_role_search_engines" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_search_engines" {
  statement {
    actions = [
      "wafv2:GetIPSet",
      "wafv2:UpdateIPSet",
    ]

    effect = "Allow"

    resources = concat(
      var.create_regional_ip_lists ? [
        aws_wafv2_ip_set.search_engines_ipv4_regional[0].arn,
        aws_wafv2_ip_set.search_engines_ipv6_regional[0].arn,
      ] : [],
      var.create_cloudfront_ip_lists ? [
        aws_wafv2_ip_set.search_engines_ipv4_cloudfront[0].arn,
        aws_wafv2_ip_set.search_engines_ipv6_cloudfront[0].arn,
      ] : []
    )
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_search_engines.function_name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.waf_search_engines.function_name}:*"
    ]
  }

  statement {
    # This is to prevent unauthorized lambdas from using WAF-LambdaRole. Any lambda function will be able to assume it,
    # but only the lambda function from this module will be able to use it.
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
        "*:${aws_lambda_function.waf_search_engines.function_name}"
      ]
    }
  }
}
