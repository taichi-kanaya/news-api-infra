# パラメータストアに設定するパラメータ
resource "aws_ssm_parameter" "app" {
  for_each = { for p in var.parameter_map : p.name => p }

  name  = each.value.name
  type  = each.value.type
  value = each.value.value
}
