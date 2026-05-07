resource "aws_iam_service_linked_role" "config" {
  count = var.create_service_linked_role ? 1 : 0

  aws_service_name = "config.amazonaws.com"

}

data "aws_iam_role" "config" {
  count = var.create_service_linked_role ? 0 : 1

  name = "AWSServiceRoleForConfig"
}

resource "aws_config_configuration_recorder" "recorder" {
  name     = "default"
  role_arn = var.create_service_linked_role ? aws_iam_service_linked_role.config[0].arn : data.aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "channel" {
  name           = "default"
  s3_bucket_name = var.delivery_channel_config.bucket_name
  sns_topic_arn  = var.delivery_channel_config.sns_topic_arn

  depends_on = [
    aws_config_configuration_recorder.recorder
  ]
}

resource "aws_config_configuration_recorder_status" "enable" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = var.enabled

  depends_on = [
    aws_config_delivery_channel.channel
  ]
}
