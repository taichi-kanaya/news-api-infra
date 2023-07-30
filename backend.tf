# tfstateはS3で管理する
terraform {
  backend "s3" {
    bucket = "tf-state-news-api"
    key    = "tfstate"
    region = "ap-northeast-1"
  }
}
