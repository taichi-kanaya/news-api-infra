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

variable "alb_security_group_id" {
  description = "ALB用セキュリティグループID"
  type        = string
  default     = null
}

variable "app_name" {
  description = "アプリケーション名"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "ドメイン名"
  type        = string
  default     = null
}

variable "public_hostzone_id" {
  description = "パブリックホストゾーンID"
  type        = string
  default     = null
}