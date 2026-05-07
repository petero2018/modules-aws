resource "random_password" "primary" {
  count  = var.password == "" ? 1 : 0
  length = 16

  #override the default special characters to avoid "@" which is not allowed for RDS
  #https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
