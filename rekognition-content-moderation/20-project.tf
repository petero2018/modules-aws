resource "aws_rekognition_project" "content_moderation" {
  name        = var.project_name
  auto_update = local.auto_update
  feature     = "CONTENT_MODERATION"
}
