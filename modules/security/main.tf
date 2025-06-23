resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-ecs-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound from ALB"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Allow SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ecs-sg"
  }
}
