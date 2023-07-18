variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default     = null
}
variable "ecr_repository_name" {
  description = "ECRのリポジトリ名"
  type        = string
  default     = null
}
