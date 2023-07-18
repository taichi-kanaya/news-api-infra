# Terraform State管理用S3バケット
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-state-${var.s3_backet_name}"
  tags   = var.tags
}
resource "aws_s3_bucket_versioning" "versioning_terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
