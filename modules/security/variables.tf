variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "web_subnet_ids" {
  description = "IDs of the web tier subnets"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "IDs of the app tier subnets"
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "IDs of the database tier subnets"
  type        = list(string)
}

variable "standby_subnet_ids" {
  description = "IDs of the standby tier subnets"
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