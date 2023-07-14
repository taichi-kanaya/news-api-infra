# パブリックなホストゾーン
resource "aws_route53_zone" "public" {
  name = "attakait.com"
  tags = var.tags
}
