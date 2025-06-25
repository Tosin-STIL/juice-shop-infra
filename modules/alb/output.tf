output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Public DNS name of the ALB"
}

output "juice_shop_tg_arn" {
  value       = aws_lb_target_group.juice_shop.arn
  description = "Target group ARN for juice-shop"
}

output "sonarqube_tg_arn" {
  value       = aws_lb_target_group.sonarqube.arn
  description = "Target group ARN for sonarqube"
}
