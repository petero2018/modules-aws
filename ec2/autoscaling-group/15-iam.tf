data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "asg_role" {
  name_prefix         = local.asg_name
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = local.iam_policy_arns

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_iam_instance_profile" "asg_profile" {
  name_prefix = local.asg_name
  role        = aws_iam_role.asg_role.name

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
