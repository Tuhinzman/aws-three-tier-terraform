output "session_manager_role_arn" {
  description = "ARN of the session manager IAM role"
  value       = aws_iam_role.session_manager_role.arn
}

output "session_manager_instance_profile_name" {
  description = "Name of the session manager instance profile"
  value       = aws_iam_instance_profile.session_manager.name
}