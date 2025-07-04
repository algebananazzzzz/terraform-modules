resource "aws_route53_record" "aliases" {
  for_each = var.cloudfront_aliases != null ? toset(var.cloudfront_aliases) : toset([])
  name     = each.value
  type     = "A"
  zone_id  = var.route53_zone_id

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }

  lifecycle {
    precondition {
      condition = anytrue([
        !var.route53_create_records,
        var.route53_zone_id != null
      ])
      error_message = "`route53_zone_id` is required if `route53_create_records` is specified"
    }
  }
}

resource "aws_route53_record" "aliases_ipv6" {
  for_each = var.cloudfront_aliases != null ? toset(var.cloudfront_aliases) : toset([])
  name     = each.value
  type     = "AAAA"
  zone_id  = var.route53_zone_id

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }

  lifecycle {
    precondition {
      condition = anytrue([
        !var.route53_create_records,
        var.route53_zone_id != null
      ])
      error_message = "`route53_zone_id` is required if `route53_create_records` is specified"
    }
  }
}
