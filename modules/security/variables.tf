variable "project" {
  description = "Project name prefix for tagging"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}
