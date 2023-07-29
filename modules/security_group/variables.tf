variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "vpc_default_security_group_id" {
  description = "VPCのデフォルトセキュリティグループID"
  type        = string
  default     = null
}