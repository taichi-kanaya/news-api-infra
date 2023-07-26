# パブリックなホストゾーン
resource "aws_route53_zone" "public" {
  name = var.public_hostzone_name
  tags = var.tags
}

# SSL証明書を発行
resource "aws_acm_certificate" "cert" {
  domain_name       = "news-api.attakait.com"
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# SSL証明書のDNS検証用のレコード
resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.public.zone_id
}

# SSL証明書のDNS検証
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
