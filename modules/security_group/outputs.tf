output "http_and_https_security_group_id" {
  description = "HTTPとHTTPSのアクセスのみを許容するセキュリティグループのID"
  value       = aws_security_group.http_and_https.id
}

output "app_security_group_id" {
  description = "アプリケーション実行用セキュリティグループのID"
  value       = aws_security_group.app.id
}
