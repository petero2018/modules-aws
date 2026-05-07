locals {
  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/redis-cluster",
  }, var.tags)

  instance_type = var.upgrade_old_instance_types ? replace(
    replace(var.node_type, "m3.", "m5."),
  "r3.", "r5.") : var.node_type

  security_group_name = coalesce(var.security_group_name, "redis-${var.redis_name}")
}
