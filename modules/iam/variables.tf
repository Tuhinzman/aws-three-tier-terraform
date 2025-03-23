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