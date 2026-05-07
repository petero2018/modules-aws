## Subnets
resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.key
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.is_public

  tags = merge(
    {
      Name     = "${var.vpc_name} ${each.value.is_public ? "public" : "private"} ${each.value.az}"
      tier     = each.value.is_public ? "public" : "private"
      vpc-name = var.vpc_name
    },
    var.tags,
    each.value.is_public ? var.public_subnet_tags : var.private_subnet_tags,
    coalesce(each.value.extra_tags, {}),
  )
}
