output "ssl_certificate_arn" {
  description = "SSL証明書のARN"
  value       = aws_acm_certificate.cert.arn
}

output "public_hostzone_id" {
  description = "パブリックホストゾーンID"
  value       = aws_route53_zone.public.zone_id
}
