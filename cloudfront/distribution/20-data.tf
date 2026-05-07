data "aws_cloudfront_cache_policy" "managed" {
  # The [var.default_behavior] array can be extended later on to include more custom behaviors
  for_each = toset([for behavior in [var.default_behavior] : behavior.cache_policy if startswith(behavior.cache_policy, "Managed-")])

  name = each.key
}
