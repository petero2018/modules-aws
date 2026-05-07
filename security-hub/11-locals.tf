locals {
  default_security_standards = [
    "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1",
    "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0",
    "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.4.0",
    "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0",
    "arn:aws:securityhub:${data.aws_region.current.name}::standards/nist-800-53/v/5.0.0",
  ]
}
