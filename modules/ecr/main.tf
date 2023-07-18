# news-apiのDockerイメージを格納するレジストリ
resource "aws_ecr_repository" "repository" {
  name = var.ecr_repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
