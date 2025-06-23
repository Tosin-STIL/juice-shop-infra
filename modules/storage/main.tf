resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.environment}-codepipeline-artifacts"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}
