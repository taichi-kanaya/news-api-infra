variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default     = null
}
variable "s3_backet_name" {
  description = "S3バケット名（※'tf-state-'は前に自動で付きます）"
  type        = string
  default     = null
}