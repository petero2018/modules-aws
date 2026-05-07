resource "aws_security_group" "custom" {
  count       = var.security_group_rules != null ? 1 : 0
  name_prefix = local.asg_name
  vpc_id      = var.vpc_id
  description = "Terraform-managed security group for autoscaling group ${var.name}"

  dynamic "ingress" {
    for_each = toset([for rule in var.security_group_rules : rule if rule.type == "ingress"])
    iterator = rule
    content {
      description     = rule.value["description"]
      to_port         = rule.value["to_port"]
      from_port       = rule.value["from_port"]
      protocol        = rule.value["protocol"]
      cidr_blocks     = rule.value["cidr_blocks"]
      security_groups = rule.value["security_group_ids"]
      self            = try(rule.value["self"], false)
    }
  }

  dynamic "egress" {
    for_each = toset([for rule in var.security_group_rules : rule if rule.type == "egress"])
    iterator = rule
    content {
      description     = rule.value["description"]
      to_port         = rule.value["to_port"]
      from_port       = rule.value["from_port"]
      protocol        = rule.value["protocol"]
      cidr_blocks     = rule.value["cidr_blocks"]
      security_groups = rule.value["security_group_ids"]
      self            = try(rule.value["self"], false)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "default" {
  name        = local.asg_name
  description = "Terraform-managed launch template for autoscaling group ${var.name}"

  update_default_version = true

  image_id      = var.ami_id
  instance_type = var.instance_types[0].instance_type

  block_device_mappings {
    device_name = var.root_volume_device_name
    ebs {
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = module.cmk.alias_arn
      volume_type           = var.root_volume_type
      volume_size           = var.root_volume_size
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.asg_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = try([aws_security_group.custom[0].id], [])
  }

  maintenance_options {
    auto_recovery = "default"
  }

  user_data = can(base64decode(var.user_data)) ? var.user_data : base64encode(var.user_data)

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  monitoring {
    enabled = true
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "group" { # tflint-ignore: aws_resource_missing_tags
  vpc_zone_identifier  = var.subnet_ids
  name                 = local.asg_name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_size
  suspended_processes  = var.suspended_processes
  termination_policies = var.termination_policies
  health_check_type    = length(var.target_group_arns) == 0 ? "EC2" : "ELB"

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy                 = "capacity-optimized-prioritized"
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = 100 - var.spot_percentage
      # Must be set to 0 when using capacity-optimized strategies
      spot_instance_pools = 0
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.default.id
        version            = aws_launch_template.default.latest_version
      }

      dynamic "override" {
        for_each = toset(slice(var.instance_types, 1, length(var.instance_types)))

        content {
          instance_type     = override.value.instance_type
          weighted_capacity = override.value.weight
        }
      }
    }
  }

  tag {
    key                 = "Name"
    value               = local.asg_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "instance_refresh" {
    for_each = var.refresh_instances_on_update ? [1] : []

    content {
      # Currently "Rolling" is the only valid value
      strategy = "Rolling"
      triggers = ["tag"]
      preferences {
        min_healthy_percentage = var.refresh_minimum_healthy_percentage
      }
    }
  }
}
