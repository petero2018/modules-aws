data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "bastion" {
  name     = "bastion"
  provider = aws.prod
}

resource "aws_security_group" "shared_ssh" {
  name        = "shared-ssh-access-${var.vpc_name}"
  description = "Allow SSH Access on port 8822 from bastion"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    var.tags
  )
}

resource "aws_security_group_rule" "bastion" {
  type                     = "ingress"
  from_port                = 8822
  to_port                  = 8822
  protocol                 = "tcp"
  security_group_id        = aws_security_group.shared_ssh.id
  source_security_group_id = data.aws_security_group.bastion.id
  description              = "Allow SSH access from bastion"
}
