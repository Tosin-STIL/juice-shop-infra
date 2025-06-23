output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "juice_shop_service_name" {
  description = "Name of the ECS service running Juice Shop"
  value       = module.ecs_juice_shop.service_name
}

output "sonarqube_service_name" {
  description = "Name of the ECS service running SonarQube"
  value       = module.ecs_sonarqube.service_name
}

output "codepipeline_name" {
  description = "The name of the CodePipeline instance"
  value       = module.codepipeline.pipeline_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}
