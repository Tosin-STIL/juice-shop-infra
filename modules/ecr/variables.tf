variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
