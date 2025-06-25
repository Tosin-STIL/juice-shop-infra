resource "aws_codebuild_project" "this" {
  name          = "${var.project}-${var.build_name}"
  description   = var.description
  build_timeout = 30

  service_role = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode # for Docker builds
    environment_variable {
      name  = "ENV"
      value = var.environment
    }
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  source {
    type            = "GITHUB"
    location        = var.source_repo
    git_clone_depth = 1
    buildspec       = var.buildspec_path
  }

  cache {
    type = "NO_CACHE"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/codebuild/${var.project}-${var.build_name}"
      stream_name = "build-log"
    }
  }

  tags = {
    Project = var.project
    Type    = var.build_name
  }
}
