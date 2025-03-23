output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "web_subnet_ids" {
  description = "IDs of the web tier subnets"
  value       = aws_subnet.web[*].id
}

output "app_subnet_ids" {
  description = "IDs of the app tier subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the database tier subnets"
  value       = aws_subnet.db[*].id
}

output "standby_subnet_ids" {
  description = "IDs of the standby tier subnets"
  value       = aws_subnet.standby[*].id
}

output "nat_gateway_ips" {
  description = "Public IPs of the NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "app_route_table_ids" {
  description = "IDs of the app tier route tables"
  value       = aws_route_table.app[*].id
}

output "db_route_table_ids" {
  description = "IDs of the database tier route tables"
  value       = aws_route_table.db[*].id
}

output "standby_route_table_ids" {
  description = "IDs of the standby tier route tables"
  value       = aws_route_table.standby[*].id
}