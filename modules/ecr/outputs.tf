output "repository_url" {
  description = "ECRリポジトリURL"
  value       = aws_ecr_repository.repository.repository_url
}
