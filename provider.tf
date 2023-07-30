# デフォルトは東京リージョンにする
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Name        = "news-api"
      Environment = "production"
    }
  }
}
