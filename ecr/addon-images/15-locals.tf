locals {
  # For addons that pull images from a region-specific ECR container registry by default
  # for more information see: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  amazon_container_image_registry_uris = tomap({
    af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com/amazon",
    ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com/amazon",
    ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com/amazon",
    ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon",
    ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com/amazon",
    ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon",
    ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/amazon",
    ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com/amazon",
    ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com/amazon",
    cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn/amazon",
    cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com.cn/amazon",
    eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon",
    eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com/amazon",
    eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com/amazon",
    eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon",
    eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon",
    eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/amazon",
    me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com/amazon",
    sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com/amazon",
    us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon",
    us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com/amazon",
    us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com/amazon",
    us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com/amazon",
    us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com/amazon",
    us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon"
  })
  # Get Local Registry
  local_registry = local.amazon_container_image_registry_uris[data.aws_region.current.name]
}
