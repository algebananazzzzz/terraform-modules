resource "aws_route53_record" "www" {
  zone_id = "Z123456789"
  name    = "example.yourdomain.com"
  type    = "A"

  alias {
    name                   = module.s3_cloudfront.distribution_domain_name
    zone_id                = module.s3_cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_acm_certificate" "cert" {
  provider = aws.us-east-1
  domain   = "yourdomain.com"
}

module "s3_cloudfront" {
  source                     = "./cloudfront_s3"
  origin_access_control_name = "ExampleOriginAccessControl"
  origin_bucket_name         = "ExampleBucket"

  cloudfront_aliases = ["example.yourdomain.com"]

  cloudfront_viewer_certificate = {
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  origin_bucket_versioning       = false
  origin_bucket_force_destroy    = false
  cloudfront_default_root_object = "index.html"
  cloudfront_price_class         = "PriceClass_200"

  cloudfront_logging_configuration = [{
    include_cookies = false
    bucket_name     = module.cloudfront_log_bucket.bucket_name
    prefix          = "logs/"
  }]

  cloudfront_custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }]

  cloudfront_geo_restriction = {
    locations        = []
    restriction_type = "none"
  }

  cloudfront_default_cache_behaviour = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }


  origin_bucket_tags = {
    Type = "origin_bucket"
  }
}


