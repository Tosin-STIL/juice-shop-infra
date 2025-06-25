output "cluster_id" {
  value       = aws_ecs_cluster.this.id
  description = "The ECS cluster ID"
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "ECS Service Name"
}

output "task_definition_arn" {
  value       = aws_ecs_task_definition.this.arn
  description = "Task definition ARN"
}
