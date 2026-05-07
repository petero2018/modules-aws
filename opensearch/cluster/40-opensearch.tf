locals {
  subnet_ids = coalesce(var.subnet_ids, slice(sort(data.aws_subnets.private.ids), 0, var.availability_zone_count))
}

data "aws_iam_policy_document" "fine_grained_open_access" {
  # https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
  #checkov:skip=CKV_AWS_283:We use fine grained access control which needs an open access policy (which means opensearch will manage the access)
  #checkov:skip=CKV_AWS_109:We use fine grained access control which needs an open access policy (which means opensearch will manage the access)
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
    ]
    actions = ["es:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_opensearch_domain" "es" {
  #checkov:skip=CKV_AWS_317:Audit logs are enabled by default
  #checkov:skip=CKV_AWS_318:We don't always want 3 dedicated master nodes
  #checkov:skip=CKV2_AWS_59:We don't always want dedicated master nodes
  #checkov:skip=CKV2_AWS_52:Fine-grained access control is enabled by default
  domain_name    = var.domain
  engine_version = "${var.engine}_${var.es_version}"

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_type    = var.dedicated_master_type
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_enabled = var.dedicated_master_count > 0 ? true : false
    zone_awareness_enabled   = var.zone_awareness

    # Warm nodes
    warm_enabled = var.warm_enabled
    warm_count   = var.warm_count
    warm_type    = var.warm_type

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  vpc_options {
    security_group_ids = [aws_security_group.security_group.id]
    subnet_ids         = local.subnet_ids
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_type = var.ebs_enabled ? var.ebs_volume_type : null
    volume_size = var.ebs_enabled ? var.ebs_volume_size : 0
    iops        = var.ebs_enabled ? var.ebs_iops : null
    throughput  = var.ebs_enabled ? var.ebs_throughput : null
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = module.cmk.key_arn
  }

  advanced_security_options {
    enabled = true

    master_user_options {
      master_user_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole"
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https                   = true
    tls_security_policy             = "Policy-Min-TLS-1-2-2019-07"
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint_certificate_arn = local.certificate_arn
    custom_endpoint                 = var.custom_endpoint
  }

  dynamic "log_publishing_options" {
    for_each = var.log_types
    content {
      enabled                  = var.logs_enabled
      cloudwatch_log_group_arn = var.logs_enabled ? aws_cloudwatch_log_group.es_log_group[0].arn : ""
      log_type                 = log_publishing_options.value
    }
  }

  off_peak_window_options {
    enabled = var.off_peak_window_enabled
    off_peak_window {
      window_start_time {
        hours   = var.off_peak_window_hours
        minutes = var.off_peak_window_minutes
      }
    }
  }

  software_update_options {
    auto_software_update_enabled = var.auto_software_update_enabled
  }

  auto_tune_options {
    desired_state = var.auto_tune_enabled ? "ENABLED" : "DISABLED"

    use_off_peak_window = true
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "indices.query.bool.max_clause_count"    = tostring(var.max_clause_count)
  }

  access_policies = data.aws_iam_policy_document.fine_grained_open_access.json

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = merge({
    Domain = var.domain
  }, var.tags)

  depends_on = [aws_iam_service_linked_role.es]
}

module "override_main_response_version" {
  count = var.engine == "OpenSearch" ? 1 : 0

  source = "../request"

  endpoint = aws_opensearch_domain.es.endpoint
  method   = "PUT"
  path     = "_cluster/settings"
  body = {
    "persistent" : {
      "compatibility.override_main_response_version" : true
    }
  }
}
