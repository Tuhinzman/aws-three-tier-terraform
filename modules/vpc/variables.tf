variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for web (public) subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app (private) subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for db (private) subnets"
  type        = list(string)
}

variable "standby_subnet_cidrs" {
  description = "CIDR blocks for standby (private) subnets"
  type        = list(string)
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}