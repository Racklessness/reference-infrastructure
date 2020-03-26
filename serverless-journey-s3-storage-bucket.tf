resource "aws_s3_bucket" "serverless-journey-storage-bucket" {
  bucket = "serverless-journey-file-storage"
  acl = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["http://localhost:8080"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "serverless-journey-storage-bucket-public-block" {
  bucket = aws_s3_bucket.serverless-journey-storage-bucket.id
  block_public_acls   = true
  block_public_policy = true
}

