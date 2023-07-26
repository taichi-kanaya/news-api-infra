output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "public subnets"
  value       = aws_subnet.public_subnets
}
