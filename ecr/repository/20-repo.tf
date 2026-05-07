module "cmk" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.0.4"

  alias       = "ecr/${var.name}"
  description = "KMS CMK Used to encrypt the ${var.name} ECR repo."

  tags = var.tags
}

resource "aws_ecr_repository" "repository" {
  name = var.name

  image_tag_mutability = var.use_immutable_image_tags ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = module.cmk.key_arn
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repository.name

  policy = data.aws_iam_policy_document.repository_policy.json
}
