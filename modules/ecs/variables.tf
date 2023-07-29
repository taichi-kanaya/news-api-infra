variable "ecs_target_group_arn" {
  description = "ECS用ターゲットグループのARN"
  type        = string
  default     = null
}

variable "app_name" {
  description = "アプリケーション名"
  type        = string
  default     = null
}

variable "ecs_task_execution_role_arn" {
  description = "ECSタスク実行ロールのARN"
  type        = string
  default     = null
}

variable "ecr_repository_url" {
  description = "ECRリポジトリURL"
  type        = string
  default     = null
}

variable "ecs_secrets" {
  description = "ECSタスクにセットする環境変数"
  type        = list(map(string))
  default     = null
}

variable "private_subnets" {
  description = "プライベートサブネット"
  type = map(object({
    id = string
  }))
  default = null
}

variable "ecs_security_group_id" {
  description = "ECSサービス用セキュリティグループID"
  type        = string
  default     = null
}
