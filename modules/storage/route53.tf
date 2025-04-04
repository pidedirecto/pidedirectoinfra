resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.letseat_hosted_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_route53_record" "cloudfront_alias" {
  zone_id = var.letseat_hosted_id
  name    = var.custom_domain_for_cloudfront
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.file_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.file_cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}