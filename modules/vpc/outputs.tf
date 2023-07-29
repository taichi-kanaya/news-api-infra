output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "public subnets"
  value       = aws_subnet.public_subnets
}

output "private_subnets" {
  description = "private subnets"
  value       = aws_subnet.private_subnets
}

output "vpc_default_security_group_id" {
  description = "vpc default security group id"
  value       = aws_vpc.main.default_security_group_id
}