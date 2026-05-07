output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS."
  value       = aws_msk_cluster.cluster.zookeeper_connect_string
}

output "bootstrap_brokers" {
  description = "A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster"
  value       = aws_msk_cluster.cluster.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster"
  value       = aws_msk_cluster.cluster.bootstrap_brokers_tls
}

output "bootstrap_brokers_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/SCRAM to the kafka cluster."
  value       = aws_msk_cluster.cluster.bootstrap_brokers_sasl_scram
}

output "bootstrap_brokers_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/IAM to the kafka cluster."
  value       = aws_msk_cluster.cluster.bootstrap_brokers_sasl_iam
}

output "config_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = local.configuration_arn
}

output "latest_revision" {
  description = "Latest revision of the configuration"
  value       = local.configuration_revision
}

output "hostname" {
  description = "Comma separated list of one or more MSK Cluster Broker DNS hostname"
  value = join(",", var.custom_broker_endpoint_enabled ? [
    for endpoint in aws_route53_record.broker_endpoint : endpoint.fqdn
  ] : local.broker_endpoints)
}

output "cluster_name" {
  description = "MSK Cluster name"
  value       = aws_msk_cluster.cluster.cluster_name
}

output "cluster_arn" {
  description = "ARN of the MSK cluster."
  value       = aws_msk_cluster.cluster.arn
}

output "security_group_ids" {
  description = "Security groups used by Kafka."
  value       = [aws_security_group.security_group.id]
}

output "subnet_ids" {
  description = "Subnet IDs used by Kafka."
  value       = local.subnet_ids
}

output "scram_users_credentials" {
  description = "Credentials for created SCRAM users: { username => password }."
  sensitive   = true
  value       = { for username in var.scram_users : username => random_password.scram_password[username].result }
}
