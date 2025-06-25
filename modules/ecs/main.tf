resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"

  tags = {
    Name = "${var.project}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  # This will load the JSON content as a string (already pre-processed from definition file)
  container_definitions = file(var.container_definitions)

  tags = {
    Name = "${var.project}-${var.service_name}-task"
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.project}-${var.service_name}-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = var.security_group_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.this]

  tags = {
    Name = "${var.project}-${var.service_name}-service"
  }
}
