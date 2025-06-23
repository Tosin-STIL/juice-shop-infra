output "project_name" {
  value       = aws_codebuild_project.this.name
  description = "The name of the CodeBuild project"
}

output "project_arn" {
  value       = aws_codebuild_project.this.arn
  description = "The ARN of the CodeBuild project"
}
