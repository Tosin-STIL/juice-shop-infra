output "pipeline_name" {
  value       = aws_codepipeline.this.name
  description = "Name of the CodePipeline"
}

output "pipeline_id" {
  value       = aws_codepipeline.this.id
  description = "ID of the CodePipeline"
}
