output "instance_a_id" {
  description = "ID of the EC2 instance A"
  value       = aws_instance.web_a.id
}

output "instance_a_public_ip" {
  description = "Public IP of the EC2 instance A"
  value       = aws_instance.web_a.public_ip
}

output "instance_a_public_dns" {
  description = "Public DNS of the EC2 instance A"
  value       = aws_instance.web_a.public_dns
}

output "instance_b_id" {
  description = "ID of the EC2 instance B"
  value       = aws_instance.web_b.id
}

output "instance_b_public_ip" {
  description = "Public IP of the EC2 instance B"
  value       = aws_instance.web_b.public_ip
}

output "instance_b_public_dns" {
  description = "Public DNS of the EC2 instance B"
  value       = aws_instance.web_b.public_dns
}