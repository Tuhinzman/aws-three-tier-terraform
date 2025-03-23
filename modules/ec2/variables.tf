variable "ami_id" {
  description = "AMI ID for EC2 instance, if empty latest Amazon Linux 2 AMI will be used"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "web_subnet_a_id" {
  description = "Web subnet A ID for first EC2 instance"
  type        = string
}

variable "web_subnet_b_id" {
  description = "Web subnet B ID for second EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}