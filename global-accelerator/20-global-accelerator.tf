resource "aws_globalaccelerator_accelerator" "accelerator" {
  #checkov:skip=CKV_AWS_75:We don't necessarily want flow logs always enabled

  name            = var.name
  ip_address_type = var.ip_address_type
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }

  tags = var.tags
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.accelerator.id
  client_affinity = var.client_affinity
  protocol        = var.protocol

  dynamic "port_range" {
    for_each = toset(var.ports)
    content {
      from_port = port_range.key
      to_port   = port_range.key
    }
  }
}
