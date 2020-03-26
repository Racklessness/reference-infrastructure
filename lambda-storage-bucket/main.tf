resource "aws_s3_bucket" "deployment-bucket" {
  bucket = var.bucket_name
  acl = "private"

  versioning {
    enabled = true
  }
}
