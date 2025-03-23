output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "web_subnet_ids" {
  description = "IDs of the web tier subnets"
  value       = module.vpc.web_subnet_ids
}

output "app_subnet_ids" {
  description = "IDs of the app tier subnets"
  value       = module.vpc.app_subnet_ids
}

output "db_subnet_ids" {
  description = "IDs of the database tier subnets"
  value       = module.vpc.db_subnet_ids
}

output "standby_subnet_ids" {
  description = "IDs of the standby tier subnets"
  value       = module.vpc.standby_subnet_ids
}

output "web_security_group_id" {
  description = "ID of the web tier security group"
  value       = module.security.web_sg_id
}

output "app_security_group_id" {
  description = "ID of the app tier security group"
  value       = module.security.app_sg_id
}

output "db_security_group_id" {
  description = "ID of the database tier security group"
  value       = module.security.db_sg_id
}

output "standby_security_group_id" {
  description = "ID of the standby tier security group"
  value       = module.security.standby_sg_id
}

output "nat_gateway_ips" {
  description = "Public IPs of the NAT Gateways"
  value       = module.vpc.nat_gateway_ips
}