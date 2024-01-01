variable "origin_bucket_name" {
  type = string
}

variable "origin_access_control_name" {
  type = string
}

variable "s3_origin_id" {
  type    = string
  default = "S3Origin"
}

variable "origin_bucket_versioning" {
  type    = string
  default = "Disabled"
}

variable "origin_bucket_force_destroy" {
  type    = bool
  default = false
}

variable "origin_bucket_tags" {
  type    = map(string)
  default = null
}

variable "cloudfront_aliases" {
  type    = list(string)
  default = null
}

variable "cloudfront_viewer_certificate" {
  type = object({
    acm_certificate_arn      = string
    minimum_protocol_version = string
    ssl_support_method       = string
  })
  default = null
}

variable "cloudfront_geo_restriction" {
  type = object({
    locations        = list(string)
    restriction_type = string
  })
  default = {
    locations        = []
    restriction_type = "none"
  }
}

variable "cloudfront_default_root_object" {
  type    = string
  default = "index.html"
}

variable "cloudfront_price_class" {
  type    = string
  default = "PriceClass_200"
}

variable "cloudfront_logging_configuration" {
  type = list(object({
    include_cookies = optional(bool)
    bucket_name     = string
    prefix          = optional(string)
  }))
  default = []
}

variable "cloudfront_custom_error_response" {
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    error_caching_min_ttl = optional(number)
    response_page_path    = optional(string)
  }))
  default = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }]
}

variable "cloudfront_default_cache_behaviour" {
  type = object({
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool
    default_ttl            = number
    min_ttl                = number
    max_ttl                = number
    viewer_protocol_policy = string
  })

  default = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }
}

variable "cloudfront_distribution_tags" {
  type    = map(string)
  default = null
}
