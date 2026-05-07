resource "aws_kinesis_stream" "streams" {
  for_each = var.streams
  name     = each.value.name

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  encryption_type = "KMS"
  kms_key_id      = "alias/aws/kinesis" # Use a Kinesis-owned master key


  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/kinesis"
  }, each.value.tags)

}
