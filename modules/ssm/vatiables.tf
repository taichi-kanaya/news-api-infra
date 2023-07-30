variable "parameter_map" {
  description = "パラメータストアにセットするパラメータのマップ"
  type        = list(map(string))
  default     = []
}
