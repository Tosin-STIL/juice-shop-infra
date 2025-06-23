resource "aws_lb" "this" {
  name               = "${var.project}-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
  internal           = false

  enable_deletion_protection = false

  tags = {
    Name = "${var.project}-alb"
  }
}

resource "aws_lb_target_group" "juice_shop" {
  name        = "${var.project}-juice-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project}-juice-tg"
  }
}

resource "aws_lb_target_group" "sonarqube" {
  name        = "${var.project}-sonar-tg"
  port        = 9000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project}-sonar-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "juice_shop" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.juice_shop.arn
  }

  condition {
    path_pattern {
      values = ["/juice-shop*", "/juice-shop"]
    }
  }
}

resource "aws_lb_listener_rule" "sonarqube" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube.arn
  }

  condition {
    path_pattern {
      values = ["/sonarqube*", "/sonarqube"]
    }
  }
}
