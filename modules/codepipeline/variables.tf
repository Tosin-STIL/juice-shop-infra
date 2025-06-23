variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "pipeline_role_arn" {
  description = "IAM role ARN assumed by CodePipeline"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner or org"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to track"
  type        = string
  default     = "main"
}

variable "github_token" {
  description = "GitHub OAuth token (use SSM for secure handling)"
  type        = string
  sensitive   = true
}

variable "build_project_name" {
  description = "Name of the CodeBuild project for Docker build"
  type        = string
}

variable "security_scan_project_name" {
  description = "Name of the CodeBuild project for SAST/SCA/IaC scans"
  type        = string
}
