variable "project" {
  description = "Name prefix for all ALB resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ALB and target groups will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}
