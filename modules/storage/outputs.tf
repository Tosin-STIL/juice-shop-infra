output "artifact_bucket_name" {
  value       = aws_s3_bucket.artifacts.id
  description = "Name of the artifact bucket"
}
