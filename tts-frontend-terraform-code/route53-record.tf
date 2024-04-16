# A hosted zone in route53 is a container of records about how you want to route traffic for a specific domain name
data "aws_route53_zone" "main_hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

# This record configuration is used to route traffic to the CloudFront distribution domain name using an A record in Route 53. 
# The A record will point to the CloudFront distribution’s domain name and will use the distribution’s hosted zone ID as the alias target
resource "aws_route53_record" "www_domain_name" {
  zone_id = data.aws_route53_zone.main_hosted_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
