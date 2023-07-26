output "ssl_certificate_arn" {
  description = "ssl certificate arn"
  value       = aws_acm_certificate.cert.arn
}
