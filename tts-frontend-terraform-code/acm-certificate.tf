# SSL Certificate from AWS ACM for your custom domain name
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# The ACM DNS validation is done after the creation of the certificate. It can take some time.
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn] //fqdn: fully qualified domain name
}

# In the validation of the AWS ACM SSL certificate, DNS records are created to verify that you have control 
# over the domain for which you are requesting the SSL certificate.
# Once the validation is successful, the SSL certificate is issued and can be used to secure communications on your website or application.
# The validation-specific DNS records are no longer necessary and can be deleted if desired.
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  # The allow_overwrite argument is set to true, which means that the resource can overwrite existing records with the same name
  allow_overwrite = true 
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main_hosted_zone.zone_id
}