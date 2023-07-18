# パブリックなホストゾーン
resource "aws_route53_zone" "public" {
  name = var.public_hostzone_name
  tags = var.tags
}
