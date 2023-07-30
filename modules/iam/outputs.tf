output "ecs_task_execution_arn" {
  description = "ECSタスク実行ロール用IAMロールのARN"
  value       = aws_iam_role.ecs_task_execution.arn
}
