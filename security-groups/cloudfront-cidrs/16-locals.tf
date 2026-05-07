locals {
  ip_ranges = jsondecode(data.http.ip_ranges.body)

  # Get every IP for the Service CLOUDFRONT
  cloudfront_ranges = [for prefix in local.ip_ranges.prefixes : prefix.ip_prefix if prefix.service == "CLOUDFRONT"]

  # Split the IP list into 3 groups to say under SG limit
  num_groups = 3

  # Calculate IPs per group
  ips_per_group = ceil(length(local.cloudfront_ranges) / local.num_groups)

  # Generate the lists of ips into groups
  ip_groups = [
    for i in range(0, local.num_groups) :
    slice(local.cloudfront_ranges, i * local.ips_per_group, min((i + 1) * local.ips_per_group, length(local.cloudfront_ranges)))
  ]

  # Assign IPs to a security group (sg_index)
  ip_map = flatten([
    for sg_index, ip_group in local.ip_groups : [
      for ip in ip_group : {
        sg_id = aws_security_group.cloudfront_sg[sg_index].id
        ip    = ip
      }
    ]
  ])

  # Generate map of IPs to loop over in aws_vpc_security_group_ingress_rule, with a key {sg_id}_{ip}
  ingress_rules = { for item in local.ip_map : "${item.sg_id}_${item.ip}" => item }
}
