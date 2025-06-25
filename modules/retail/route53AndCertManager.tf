resource "aws_route53_zone" "main" {
  name = "ambitretail.com"
}

resource "aws_acm_certificate" "wildcard" {
  domain_name               = "ambitretail.com"
  validation_method         = "DNS"
  subject_alternative_names = [
    "api.ambitretail.com",
    "billing.ambitretail.com"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "app_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.ambitretail.com"
  type    = "A"

  alias {
    name                   = aws_lb.retail_alb.dns_name
    zone_id                = aws_lb.retail_alb.zone_id
    evaluate_target_health = true
  }
}