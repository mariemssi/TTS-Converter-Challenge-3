# Origin Access Control OAC is a secure way for a cloudfront distribution to access S3 origins 
# It is used to allow only the designated CloudFront distribution to access the associated S3 buckets.
# OAC provides short term credentials, and frequent credential rotations
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC ${aws_s3_bucket.tts_frontend_bucket.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [aws_s3_bucket.tts_frontend_bucket]

  comment         = "${var.domain_name} distribution"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  price_class     = "PriceClass_100" # you can use this class for only North America and Europe

  # The aliases argument specifies a list of domain names that are associated with the distribution
  aliases = [
    "www.${var.domain_name}"
  ]

  # index.html is the file in the S3 bucket (default origin) that must be loaded 
  # when we hit the / path of the CloudFront distribution URL.
  default_root_object = "index.html"


  # The first origin for CF distribution is S3
  origin {
    domain_name              = aws_s3_bucket.tts_frontend_bucket.bucket_regional_domain_name
    origin_id                = "${var.bucket_name}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # There are two types of cache behaviors: default and ordered. When a request arrives 
  # CloudFront tries to match the path to the ordered cache behaviors one by one until a match is found. 
  # If none matches, it will use the default. The ordering is important in cases where a given path matches multiple behaviors. 
  # In this case, it matters which one is the first.
  # The default behavior catches everything, so you don't need to specify a path_pattern. 
  # You can think that it's a hardcoded *.
  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"        // CloudFront should redirect HTTP traffic to HTTPS
    allowed_methods        = ["GET", "HEAD", "OPTIONS"] // The HTTP method that the distribution can accept
    cached_methods         = ["GET", "HEAD"]            // The HTTP methods that the distribution can cache
    compress               = true
    target_origin_id       = "${var.bucket_name}-origin"

    # The Default, Minimum, and Maximum TTLs are set to 0 seconds. In this case, CloudFront always verifies that it has the most recent content from the origin.
    # If the origin doesn't provide cache headers, such as Cache-Control max-age or Expires, then CloudFront caches the object for the Default TTL duration.
    # min_ttl     = 0
    # default_ttl = 0
    # max_ttl     = 0

  }

  # The second origin for CF distribution is the api-gateway
  # For more details about how to set origin path and path pattern: https://advancedweb.hu/how-to-use-api-gateway-with-cloudfront/
  origin {
    domain_name = replace(var.api_gateway_invoke_URL, "/^https?://([^/]*).*/", "$1") //"replace" is a function used to extrat the domain from the api gateway invoke url
    origin_id   = "apigw"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # The cache behavior of the second origin (custom)
  ordered_cache_behavior {
    path_pattern     = "/test/TextToSpeechConverter*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "apigw"

    # Time-To-Live (TTL) values is the duration of objects in the distribution to be cached (in edge locations)
    # APIs are usually not cacheable so set 0 for all TTLs
    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0

    forwarded_values {
      query_string = true
      headers      = ["none"] //important to set this param to not have 403 error
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only" //Server Name Indication (SNI) is for support multiple SSL/TLS certificates on the same IP address
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
