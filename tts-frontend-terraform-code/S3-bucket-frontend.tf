# Create the S3 bucket to contain all frontend files: HTML, CSS and javascript files  
resource "aws_s3_bucket" "tts_frontend_bucket" {
  bucket = var.bucket_name

  #To allow destroy a non empty bucket
  force_destroy = true
}

# This configuration sets up the S3 bucket to behave like a web server
resource "aws_s3_bucket_website_configuration" "frontend_bucket" {
  bucket = aws_s3_bucket.tts_frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

# S3 bucket ACL access - establishes that the default owner of the bucket objects is the bucket owner
resource "aws_s3_bucket_ownership_controls" "frontend_bucket" {
  bucket = aws_s3_bucket.tts_frontend_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#The bucket is not publically accessible
resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket = aws_s3_bucket.tts_frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_acl" "website_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.frontend_bucket,
    aws_s3_bucket_public_access_block.frontend_bucket,
  ]

  bucket = aws_s3_bucket.tts_frontend_bucket.id
  acl    = "private"
}
