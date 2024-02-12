locals {
  use_custom_viewer_certificate = var.cloudfront_viewer_certificate != null
}

resource "aws_cloudfront_distribution" "this" {
  aliases             = var.cloudfront_aliases
  enabled             = var.cloudfront_enabled
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled
  default_root_object = var.cloudfront_default_root_object
  price_class         = var.cloudfront_price_class

  origin {
    domain_name              = local.create_new_bucket ? aws_s3_bucket.new[0].bucket_regional_domain_name : var.origin_bucket_use_existing.bucket_regional_domain_name
    origin_id                = var.cloudfront_s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_response

    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  dynamic "logging_config" {
    for_each = var.cloudfront_logging_configuration != null ? [1] : []

    content {
      include_cookies = var.cloudfront_logging_configuration.include_cookies
      bucket          = "${var.cloudfront_logging_configuration.bucket_name}.s3.amazonaws.com"
      prefix          = var.cloudfront_logging_configuration.prefix
    }
  }

  default_cache_behavior {
    allowed_methods  = var.cloudfront_default_cache_behaviour.allowed_methods
    cached_methods   = var.cloudfront_default_cache_behaviour.cached_methods
    target_origin_id = var.cloudfront_s3_origin_id
    cache_policy_id  = var.cloudfront_default_cache_behaviour.cache_policy_id

    viewer_protocol_policy = var.cloudfront_default_cache_behaviour.viewer_protocol_policy
    min_ttl                = var.cloudfront_default_cache_behaviour.min_ttl
    default_ttl            = var.cloudfront_default_cache_behaviour.default_ttl
    max_ttl                = var.cloudfront_default_cache_behaviour.max_ttl
    compress               = var.cloudfront_default_cache_behaviour.compress
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction.restriction_type
      locations        = var.cloudfront_geo_restriction.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = local.use_custom_viewer_certificate ? var.cloudfront_viewer_certificate.acm_certificate_arn : null
    cloudfront_default_certificate = local.use_custom_viewer_certificate ? false : true
    minimum_protocol_version       = local.use_custom_viewer_certificate ? var.cloudfront_viewer_certificate.minimum_protocol_version : "TLSv1"
    ssl_support_method             = local.use_custom_viewer_certificate ? var.cloudfront_viewer_certificate.ssl_support_method : null
  }

  tags = var.cloudfront_distribution_tags
}
