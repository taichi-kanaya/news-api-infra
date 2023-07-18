variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default     = null
}
variable "public_hostzone_name" {
  description = "パブリックホストゾーン名"
  type        = string
  default     = null
}
