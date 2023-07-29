output "ssl_certificate_arn" {
  description = "ssl certificate arn"
  value       = aws_acm_certificate.cert.arn
}

output "public_hostzone_id" {
  description = "パブリックホストゾーンID"
  value       = aws_route53_zone.public.zone_id
}
