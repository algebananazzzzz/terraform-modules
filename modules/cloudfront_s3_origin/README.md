# Cloudfront S3 Origin Module

Provisions a Cloudfront Distribution with an S3 bucket origin

## Basic Example
```hcl
module "cloudfront_s3" {
  source = "./modules/cloudfront_s3_origin"
}
```

## Full Configuration Example
```hcl
module "cloudfront_s3" {
  source = "./modules/cloudfront_s3_origin"

  # Optional Origin Access Control Variables
  origin_access_control_name             = "S3Origin"
  origin_access_control_description      = "Origin Access Control for S3 Origin"
  origin_access_control_signing_behavior = "always"

  # Optional Origin Bucket Variables
  origin_bucket_name              = "dev-app-s3bucket-example"
  origin_bucket_force_destroy     = false
  origin_bucket_versioning_status = "Disabled"
  origin_bucket_tags = {
    foo = "bar"
  }
  # Use existing bucket instead (omit above bucket variables)
  # origin_bucket_use_existing = {
  #   bucket_regional_domain_name = aws_s3_bucket.this.bucket_regional_domain_name
  #   arn                         = aws_s3_bucket.this.arn
  #   id                          = aws_s3_bucket.this.id
  #   create_bucket_policy        = true
  # }

  # Route53 Variables
  route53_create_records = true
  route53_zone_id        = "Z123456789"

  # Optional Cloudfront Distribution Variables
  cloudfront_s3_origin_id    = "DefaultS3Origin"
  cloudfront_enabled         = true
  cloudfront_is_ipv6_enabled = true
  cloudfront_aliases         = ["test.example.com"]
  cloudfront_custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }]
  cloudfront_default_cache_behaviour = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }
  cloudfront_viewer_certificate = {
    acm_certificate_arn      = "arn:aws:acm:region:account:certificate/certificate_ID"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
  cloudfront_geo_restriction = {
    locations        = []
    restriction_type = "none"
  }
  cloudfront_default_root_object = "index.html"
  cloudfront_price_class         = "PriceClass_200"
  cloudfront_logging_configuration = {
    include_cookies = false
    bucket_name     = "dev-mgmt-s3bucket-logbucket"
    prefix          = "logs/"
  }
  cloudfront_distribution_tags = {
    foo = "bar"
  }
}
```