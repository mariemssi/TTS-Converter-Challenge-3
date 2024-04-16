# Attach the S3 bucket policy to the S3 frontend bucket
resource "aws_s3_bucket_policy" "attach_S3_policy" {
  bucket = aws_s3_bucket.tts_frontend_bucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront_OAC_Access_S3.json
}

# Define an IAM bucket policy allowing CloudFront to access S3
data "aws_iam_policy_document" "allow_cloudfront_OAC_Access_S3" {
  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.tts_frontend_bucket.arn,
      "${aws_s3_bucket.tts_frontend_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}