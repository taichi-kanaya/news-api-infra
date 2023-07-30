output "vpc_id" {
  description = "VPCのID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "パブリックサブネット（複数）"
  value       = aws_subnet.public_subnets
}

output "private_subnets" {
  description = "プライベートサブネット（複数）"
  value       = aws_subnet.private_subnets
}

output "vpc_default_security_group_id" {
  description = "VPCのデフォルトセキュリティグループのID"
  value       = aws_vpc.main.default_security_group_id
}