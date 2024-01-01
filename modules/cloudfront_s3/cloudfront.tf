resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = var.origin_access_control_name
  description                       = "Origin Access Control for S3 Origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.origin_bucket.bucket_regional_domain_name
    origin_id                = var.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.cloudfront_default_root_object
  price_class         = var.cloudfront_price_class

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
    for_each = var.cloudfront_logging_configuration
    content {
      include_cookies = logging_config.value.include_cookies
      bucket          = "${logging_config.value.bucket_name}.s3.amazonaws.com"
      prefix          = logging_config.value.prefix
    }
  }


  default_cache_behavior {
    allowed_methods  = var.cloudfront_default_cache_behaviour.allowed_methods
    cached_methods   = var.cloudfront_default_cache_behaviour.cached_methods
    target_origin_id = var.s3_origin_id

    viewer_protocol_policy = var.cloudfront_default_cache_behaviour.viewer_protocol_policy
    min_ttl                = var.cloudfront_default_cache_behaviour.min_ttl
    default_ttl            = var.cloudfront_default_cache_behaviour.default_ttl
    max_ttl                = var.cloudfront_default_cache_behaviour.max_ttl
    compress               = var.cloudfront_default_cache_behaviour.compress

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction.restriction_type
      locations        = var.cloudfront_geo_restriction.locations
    }
  }

  aliases = var.cloudfront_aliases

  viewer_certificate {
    acm_certificate_arn            = var.cloudfront_viewer_certificate != null ? var.cloudfront_viewer_certificate.acm_certificate_arn : null
    cloudfront_default_certificate = var.cloudfront_viewer_certificate != null ? false : true
    minimum_protocol_version       = var.cloudfront_viewer_certificate != null ? var.cloudfront_viewer_certificate.minimum_protocol_version : "TLSv1"
    ssl_support_method             = var.cloudfront_viewer_certificate != null ? var.cloudfront_viewer_certificate.ssl_support_method : null
  }

  tags = var.cloudfront_distribution_tags

  depends_on = [aws_s3_bucket.origin_bucket]
}
