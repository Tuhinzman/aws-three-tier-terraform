variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "three-tier-architecture"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for web (public) subnets"
  type        = list(string)
  default     = ["10.0.48.0/20", "10.0.112.0/20", "10.0.176.0/20"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app (private) subnets"
  type        = list(string)
  default     = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for db (private) subnets"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.80.0/20", "10.0.144.0/20"]
}

variable "standby_subnet_cidrs" {
  description = "CIDR blocks for standby (private) subnets"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.64.0/20", "10.0.128.0/20"]
}