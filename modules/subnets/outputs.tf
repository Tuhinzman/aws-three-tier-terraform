output "reserved_subnet_a_id" {
  description = "ID of reserved subnet A"
  value       = aws_subnet.reserved_a.id
}

output "reserved_subnet_b_id" {
  description = "ID of reserved subnet B"
  value       = aws_subnet.reserved_b.id
}

output "reserved_subnet_c_id" {
  description = "ID of reserved subnet C"
  value       = aws_subnet.reserved_c.id
}

output "db_subnet_a_id" {
  description = "ID of database subnet A"
  value       = aws_subnet.db_a.id
}

output "db_subnet_b_id" {
  description = "ID of database subnet B"
  value       = aws_subnet.db_b.id
}

output "db_subnet_c_id" {
  description = "ID of database subnet C"
  value       = aws_subnet.db_c.id
}

output "app_subnet_a_id" {
  description = "ID of application subnet A"
  value       = aws_subnet.app_a.id
}

output "app_subnet_b_id" {
  description = "ID of application subnet B"
  value       = aws_subnet.app_b.id
}

output "app_subnet_c_id" {
  description = "ID of application subnet C"
  value       = aws_subnet.app_c.id
}

output "web_subnet_a_id" {
  description = "ID of web subnet A"
  value       = aws_subnet.web_a.id
}

output "web_subnet_b_id" {
  description = "ID of web subnet B"
  value       = aws_subnet.web_b.id
}

output "web_subnet_c_id" {
  description = "ID of web subnet C"
  value       = aws_subnet.web_c.id
}

output "web_subnet_ids" {
  description = "List of all web subnet IDs"
  value       = [aws_subnet.web_a.id, aws_subnet.web_b.id, aws_subnet.web_c.id]
}

output "app_subnet_ids" {
  description = "List of all app subnet IDs"
  value       = [aws_subnet.app_a.id, aws_subnet.app_b.id, aws_subnet.app_c.id]
}

output "db_subnet_ids" {
  description = "List of all database subnet IDs"
  value       = [aws_subnet.db_a.id, aws_subnet.db_b.id, aws_subnet.db_c.id]
}