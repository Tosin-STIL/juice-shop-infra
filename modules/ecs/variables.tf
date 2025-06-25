variable "project" {
  description = "Name prefix for all ECS resources"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service (e.g., juice-shop, sonarqube)"
  type        = string
}

variable "task_family" {
  description = "Family name for the task definition"
  type        = string
}

variable "container_name" {
  description = "Name of the container inside the task"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "cpu" {
  description = "CPU units for Fargate"
  type        = string
  default     = "512"
}

variable "memory" {
  description = "Memory in MiB for Fargate"
  type        = string
  default     = "1024"
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the task"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to run ECS tasks in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs attached to ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN for service registration"
  type        = string
}

variable "container_definitions" {
  description = "Full JSON of container definitions"
  type        = string
}
