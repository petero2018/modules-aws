data "aws_iam_policy_document" "cmk" {
  #checkov:skip=CKV_AWS_111:This is a resource-based policy. "*" in this case applies only to the resource to which this policy is attached.
  #checkov:skip=CKV_AWS_109:This is a resource-based policy. "*" in this case applies only to the resource to which this policy is attached.
  statement {
    sid    = "Allow service-linked role to use KMS Key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }

    actions = [
      "kms:CreateGrant"
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values = [
        true
      ]
    }
  }
}

module "cmk" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.0.1"

  alias       = local.asg_name
  description = "KMS CMK Used to encrypt ${local.asg_name} autoscaling group resources."
  key_policy  = data.aws_iam_policy_document.cmk.json

  tags = var.tags
}
