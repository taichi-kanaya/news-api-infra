output "ecs_target_group_arn" {
  description = "ECSから転送するターゲットグループのARN"
  value       = aws_lb_target_group.public_alb.arn
}
