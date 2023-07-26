output "ecs_target_group_arn" {
  description = "ecs target group arn"
  value       = aws_lb_target_group.public_alb.arn
}
