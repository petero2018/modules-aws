locals {
  resource_type_opt_in_preference = {
    "Aurora"                 = true
    "DocumentDB"             = true
    "DynamoDB"               = true
    "EBS"                    = true
    "EC2"                    = true
    "EFS"                    = true
    "FSx"                    = true
    "Neptune"                = true
    "RDS"                    = true
    "Storage Gateway"        = true
    "S3"                     = true
    "VirtualMachine"         = true
    "CloudFormation"         = false
    "Redshift"               = false
    "SAP HANA on Amazon EC2" = false
  }

  resource_type_management_preference = {
    "DynamoDB" = true
    "EFS"      = true
  }
}

resource "aws_backup_region_settings" "vault" {
  resource_type_opt_in_preference     = local.resource_type_opt_in_preference
  resource_type_management_preference = local.resource_type_management_preference

  lifecycle {
    ignore_changes = [
      resource_type_opt_in_preference,
    ]
  }

}
