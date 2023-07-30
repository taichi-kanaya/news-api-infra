locals {
  public_subnets = [
    { cidr_block = "10.0.0.0/18", availability_zone = "ap-northeast-1a" },
    { cidr_block = "10.0.64.0/18", availability_zone = "ap-northeast-1c" }
  ]
  private_subnets = [
    { cidr_block = "10.0.128.0/18", availability_zone = "ap-northeast-1a" },
    { cidr_block = "10.0.192.0/18", availability_zone = "ap-northeast-1c" }
  ]
}

# news-api専用VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# パブリックサブネット（マルチAZ）
resource "aws_subnet" "public_subnets" {
  for_each = { for s in local.public_subnets : s.cidr_block => s }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
}

# プライベートサブネット（マルチAZ）
resource "aws_subnet" "private_subnets" {
  for_each = { for s in local.private_subnets : s.cidr_block => s }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = false
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# パブリックサブネット用ルートテーブル
resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# パブリックサブネットにルートテーブルを紐付ける
resource "aws_route_table_association" "public_subnets" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_subnet.id
}

# NATゲートウェイ用EIP
resource "aws_eip" "nat" {
  for_each = aws_subnet.public_subnets

  domain = "vpc"
}

# NATゲートウェイ
resource "aws_nat_gateway" "public_subnet" {
  for_each = aws_subnet.public_subnets

  subnet_id     = each.value.id
  allocation_id = aws_eip.nat[each.key].id
  depends_on    = [aws_internet_gateway.gw]
}

# プライベートサブネット用ルートテーブル
resource "aws_route_table" "private_subnets" {
  for_each = aws_nat_gateway.public_subnet

  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }
}

# プライベートサブネットにルートテーブルを紐付ける
locals {
  rt_keys     = tolist(keys(aws_route_table.private_subnets))
  subnet_keys = tolist(keys(aws_subnet.private_subnets))
}
resource "aws_route_table_association" "private_subnets" {
  for_each = {
    for i in range(length(local.rt_keys)) :
    local.rt_keys[i] => local.subnet_keys[i]
  }

  subnet_id      = aws_subnet.private_subnets[each.value].id
  route_table_id = aws_route_table.private_subnets[each.key].id
}
