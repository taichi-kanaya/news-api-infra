# news-api専用VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# パブリックサブネット（マルチAZ）
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

# プライベートサブネット（マルチAZ）
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.128.0/18"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.192.0/18"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}
