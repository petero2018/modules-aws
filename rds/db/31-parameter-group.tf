locals {
  # Engine + MAJOR.MINOR of engine version
  family_tmp = "${var.engine}${replace(var.engine_version, "/([0-9]+\\.[0-9]+).*/", "$1")}"
  # Strips MINOR engine version for postgres10+
  family = replace(local.family_tmp, "/(postgres1[0-9]+).*/", "$1")

  param_group_suffix = var.use_parameter_group_suffix ? "-${replace(var.engine_version, ".", "-")}" : ""

  # This is to fit with compatibility of existing resources
  # Ideally we'll replace this with a consistent approach for both and delete this nastiness
  param_group_name = {
    postgres = replace("${var.environment}-${var.name}-${var.engine}${local.param_group_suffix}", "postgres-postgres", "postgres")
    mysql    = "${var.environment}-${var.engine}-${var.name}${local.param_group_suffix}"
  }

  param_group_desc = {
    postgres = "Parameter Group for ${replace(local.param_group_name.postgres, "-postgres", "")} PostgreSQL."
    mysql    = "Parameter Group for ${local.param_group_name.mysql} MySQL (${local.family})."
  }

  param_group_role = {
    postgres = replace("postgres-${var.name}", "postgres-postgres", "postgres")
    mysql    = replace("${local.family}-${var.name}", ".", "")
  }
}

resource "aws_db_parameter_group" "primary" {
  name        = var.use_parameter_group_name_as_prefix ? null : coalesce(var.parameter_group_name, local.param_group_name[var.engine])
  name_prefix = var.use_parameter_group_name_as_prefix ? coalesce(var.parameter_group_name, local.param_group_name[var.engine]) : null
  family      = local.family
  description = coalesce(var.parameter_group_description, local.param_group_desc[var.engine])

  dynamic "parameter" {
    for_each = var.use_default_parameters ? merge(var.default_parameters[local.family], var.parameters) : var.parameters

    content {
      name         = parameter.key
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge({
    Env  = var.environment
    Role = local.param_group_role[var.engine]
  }, local.base_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "replica" {
  for_each = {
    for key, config in var.replica_configurations :
    key => config
    if length(config.parameters) > 0
  }

  name_prefix = coalesce(each.value.parameter_group_name, "${local.param_group_name[var.engine]}-${each.key}")
  family      = local.family
  description = coalesce(each.value.parameter_group_description, "${local.param_group_desc[var.engine]} Replica.")

  dynamic "parameter" {
    for_each = each.value.use_default_parameters ? merge(var.default_parameters[local.family], each.value.parameters) : each.value.parameters

    content {
      name         = parameter.key
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge({
    Env  = var.environment
    Role = local.param_group_role[var.engine]
  }, local.base_tags)

  lifecycle {
    create_before_destroy = true
  }
}

moved {
  from = aws_db_parameter_group.replica[0]
  to   = aws_db_parameter_group.replica["replica"]
}
