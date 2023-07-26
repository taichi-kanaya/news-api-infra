variable "tags" {
  description = "AWSリソース用のタグ"
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "Subnetオブジェクトのマップ"
  type = map(object({
    id = string
  }))
  default = {}
}

variable "ssl_certificate_arn" {
  description = "ssl certificate arn"
  type        = string
  default     = null
}
