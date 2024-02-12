##################################################
# Origin Access Control Variables
##################################################

variable "origin_access_control_name" {
  type        = string
  description = "A name that identifies the Origin Access Control providing S3 origin access to cloudfront. Defaults to the buckets `bucket_regional_domain_name`."
  default     = null
}

variable "origin_access_control_description" {
  type        = string
  default     = "Origin Access Control for S3 Origin"
  description = "The description of the Origin Access Control providing S3 origin access to cloudfront."
}

variable "origin_access_control_signing_behavior" {
  type        = string
  default     = "always"
  description = "Specifies which requests CloudFront signs. Allowed values: `always`, `never`, and `no-override`."
}

##################################################
# Origin Bucket Variables
##################################################

variable "origin_bucket_name" {
  description = "Name of the origin bucket to be created"
  type        = string
  default     = null
}

variable "origin_bucket_force_destroy" {
  description = "Boolean that indicates all objects should be deleted from the origin bucket when the bucket is destroyed through Terraform."
  type        = bool
  default     = false
}

variable "origin_bucket_tags" {
  description = "Map of tags to assign to the origin bucket."
  type        = map(string)
  default     = null
}

variable "origin_bucket_versioning_status" {
  description = "Versioning state of the origin bucket. Valid values: `Enabled`, `Suspended`, or `Disabled`."
  type        = string
  default     = "Disabled"
}

variable "origin_bucket_use_existing" {
  description = "Output values of an s3 origin bucket if you wish to manage and create an origin bucket outside this module."
  type = object({
    create_bucket_policy        = bool
    arn                         = string
    id                          = string
    bucket_regional_domain_name = string
  })
  default = null
}

##################################################
# Route53 Variables
##################################################

variable "route53_create_records" {
  description = "Boolean on whether to create route53 record(s) (simple alias record) for the cloudfront alias(es)."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "The ID of the hosted zone to contain this record."
  type        = string
  default     = null
}

##################################################
# Cloudfront Distribution Variables
##################################################
variable "cloudfront_s3_origin_id" {
  type        = string
  description = "Unique identifier for the s3 origin within the cloudfront distribution."
  default     = "DefaultS3Origin"
}

variable "cloudfront_enabled" {
  type        = bool
  description = "Whether the distribution is enabled to accept end user requests for content."
  default     = true
}

variable "cloudfront_is_ipv6_enabled" {
  type        = string
  description = "Whether IPv6 is enabled for the distribution."
  default     = true
}

variable "cloudfront_aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names) for the cloudfront distribution."
  default     = null
}

variable "cloudfront_custom_error_response" {
  description = "Configuration for a list of custom error response for the cloudfront distribution."
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
  description = " Default cache behavior for this distribution. Defaults to only cache [`GET`, `POST`] methods for `cached_methods` and CachingOptimized policy for `cache_policy_id`."
  type = object({
    allowed_methods        = list(string)
    cached_methods         = list(string)
    cache_policy_id        = optional(string)
    compress               = optional(bool)
    default_ttl            = optional(number)
    min_ttl                = optional(number)
    max_ttl                = optional(number)
    viewer_protocol_policy = string
  })

  default = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }
}

variable "cloudfront_viewer_certificate" {
  description = "The SSL configuration for the cloudfront distribution. Omit this to use the cloudfront default certificate."
  type = object({
    acm_certificate_arn      = string
    minimum_protocol_version = optional(string)
    ssl_support_method       = string
  })
  default = null
}

variable "cloudfront_geo_restriction" {
  description = "Configuration for CloudFront to limit the distribution of your content geographically. Omit this to apply no restrictions."
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
  description = "Object that you want CloudFront to return when an end user requests the root URL."
  type        = string
  default     = "index.html"
}

variable "cloudfront_price_class" {
  description = "Price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`."
  type        = string
  default     = "PriceClass_200"
}

variable "cloudfront_logging_configuration" {
  description = "Configuration to enable the Cloudfront distribution to write logs to an s3 bucket."
  type = object({
    include_cookies = optional(bool)
    bucket_name     = string
    prefix          = optional(string)
  })
  default = null
}

variable "cloudfront_distribution_tags" {
  type    = map(string)
  default = null
}
