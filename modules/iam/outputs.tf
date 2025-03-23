output "web_role_arn" {
  description = "ARN of the web tier IAM role"
  value       = aws_iam_role.web_role.arn
}

output "app_role_arn" {
  description = "ARN of the app tier IAM role"
  value       = aws_iam_role.app_role.arn
}

output "web_instance_profile_name" {
  description = "Name of the web tier instance profile"
  value       = aws_iam_instance_profile.web_profile.name
}

output "app_instance_profile_name" {
  description = "Name of the app tier instance profile"
  value       = aws_iam_instance_profile.app_profile.name
}