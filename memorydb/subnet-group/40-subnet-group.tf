resource "aws_memorydb_subnet_group" "subnet_group" {
  name       = "${var.prefix}-${var.name}"
  subnet_ids = var.subnet_ids

  tags = var.tags
}
