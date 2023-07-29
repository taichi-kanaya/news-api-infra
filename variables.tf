variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default = {
    Name        = "news-api"
    Environment = "production"
  }
}

variable "app_name" {
  description = "アプリケーション名"
  type        = string
  default     = "news-api"
}

variable "domain_name" {
  description = "ドメイン名"
  type        = string
  default     = "attakait.com"
}
