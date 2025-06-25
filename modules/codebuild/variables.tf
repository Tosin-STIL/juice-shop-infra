variable "project" {
  description = "Name of the overall project"
  type        = string
}

variable "build_name" {
  description = "Unique name for the CodeBuild job (e.g., build, scan)"
  type        = string
}

variable "description" {
  description = "Description of the build project"
  type        = string
}

variable "codebuild_role_arn" {
  description = "IAM Role ARN for CodeBuild to assume"
  type        = string
}

variable "source_repo" {
  description = "GitHub repo URL for source code"
  type        = string
}

variable "buildspec_path" {
  description = "Relative path to buildspec file (e.g. buildspec.yml)"
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., prod)"
  type        = string
}

variable "privileged_mode" {
  description = "Whether Docker commands are allowed"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "Map of environment variables for build"
  type        = map(string)
  default     = {}
}
