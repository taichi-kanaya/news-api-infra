# news-apiのDockerイメージを格納するレジストリ
resource "aws_ecr_repository" "news-api" {
  name = "news-api"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
