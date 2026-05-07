## VPC
resource "aws_vpc" "vpc" {
  #checkov:skip=CKV2_AWS_11:skip check for flow logs for now as it will be added in later release
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = merge({
    Name = var.vpc_name
  }, var.tags, var.vpc_tags)
}

## Security group to default deny all traffic
resource "aws_default_security_group" "default_deny" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    Name = "${var.vpc_name} default security group"
  }, var.tags)
}

## Policy to default deny all traffic outside of the VPC CIDR
resource "aws_iam_policy" "vpc_cidr_restriction" {
  count = var.create_vpc_policy ? 1 : 0

  name        = join("", [var.vpc_name, "VpcCidrRestriction"])
  path        = var.policy_path
  description = "Restrict access to its VPC CIDR"
  policy      = data.aws_iam_policy_document.vpc_cidr_restriction.json
  tags        = var.tags
}

data "aws_iam_policy_document" "vpc_cidr_restriction" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Deny"

    condition {
      test     = "Null"
      variable = "aws:TokenIssueTime"
      values   = ["true"]
    }

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.vpc_source_ips
    }

  }
}
