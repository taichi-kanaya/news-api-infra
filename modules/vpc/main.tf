# news-api専用VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = var.tags
}

# パブリックサブネット（マルチAZ）
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags                    = var.tags
}
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags                    = var.tags
}

# プライベートサブネット（マルチAZ）
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.128.0/18"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags                    = var.tags
}
resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.192.0/18"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags                    = var.tags
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}
