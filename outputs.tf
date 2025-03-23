output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_web_a_id" {
  description = "ID of the web subnet in AZ A"
  value       = module.subnets.web_subnet_a_id
}

output "subnet_web_b_id" {
  description = "ID of the web subnet in AZ B"
  value       = module.subnets.web_subnet_b_id
}

output "subnet_web_c_id" {
  description = "ID of the web subnet in AZ C"
  value       = module.subnets.web_subnet_c_id
}

output "subnet_app_a_id" {
  description = "ID of the app subnet in AZ A"
  value       = module.subnets.app_subnet_a_id
}

output "subnet_app_b_id" {
  description = "ID of the app subnet in AZ B"
  value       = module.subnets.app_subnet_b_id
}

output "subnet_app_c_id" {
  description = "ID of the app subnet in AZ C"
  value       = module.subnets.app_subnet_c_id
}

output "subnet_db_a_id" {
  description = "ID of the db subnet in AZ A"
  value       = module.subnets.db_subnet_a_id
}

output "subnet_db_b_id" {
  description = "ID of the db subnet in AZ B"
  value       = module.subnets.db_subnet_b_id
}

output "subnet_db_c_id" {
  description = "ID of the db subnet in AZ C"
  value       = module.subnets.db_subnet_c_id
}

output "subnet_reserved_a_id" {
  description = "ID of the reserved subnet in AZ A"
  value       = module.subnets.reserved_subnet_a_id
}

output "subnet_reserved_b_id" {
  description = "ID of the reserved subnet in AZ B"
  value       = module.subnets.reserved_subnet_b_id
}

output "subnet_reserved_c_id" {
  description = "ID of the reserved subnet in AZ C"
  value       = module.subnets.reserved_subnet_c_id
}

output "public_instance_a_id" {
  description = "ID of the public EC2 instance A"
  value       = module.ec2.instance_a_id
}

output "public_instance_a_public_ip" {
  description = "Public IP of the EC2 instance A"
  value       = module.ec2.instance_a_public_ip
}

output "public_instance_b_id" {
  description = "ID of the public EC2 instance B"
  value       = module.ec2.instance_b_id
}

output "public_instance_b_public_ip" {
  description = "Public IP of the EC2 instance B"
  value       = module.ec2.instance_b_public_ip
}