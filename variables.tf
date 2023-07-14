variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default = {
    Name        = "news-api"
    Environment = "production"
  }
}
