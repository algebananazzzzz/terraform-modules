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
<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.aliases](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_versioning.create_new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_aliases"></a> [cloudfront\_aliases](#input\_cloudfront\_aliases) | Extra CNAMEs (alternate domain names) for the cloudfront distribution. | `list(string)` | `null` | no |
| <a name="input_cloudfront_custom_error_response"></a> [cloudfront\_custom\_error\_response](#input\_cloudfront\_custom\_error\_response) | Configuration for a list of custom error response for the cloudfront distribution. | <pre>list(object({<br>    error_code            = number<br>    response_code         = optional(number)<br>    error_caching_min_ttl = optional(number)<br>    response_page_path    = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "error_code": 404,<br>    "response_code": 404,<br>    "response_page_path": "/404.html"<br>  }<br>]</pre> | no |
| <a name="input_cloudfront_default_cache_behaviour"></a> [cloudfront\_default\_cache\_behaviour](#input\_cloudfront\_default\_cache\_behaviour) | Default cache behavior for this distribution. Defaults to only cache [`GET`, `POST`] methods for `cached_methods` and CachingOptimized policy for `cache_policy_id`. | <pre>object({<br>    allowed_methods        = list(string)<br>    cached_methods         = list(string)<br>    cache_policy_id        = optional(string)<br>    compress               = optional(bool)<br>    default_ttl            = optional(number)<br>    min_ttl                = optional(number)<br>    max_ttl                = optional(number)<br>    viewer_protocol_policy = string<br>  })</pre> | <pre>{<br>  "allowed_methods": [<br>    "GET",<br>    "HEAD",<br>    "OPTIONS"<br>  ],<br>  "cache_policy_id": "658327ea-f89d-4fab-a63d-7e88639e58f6",<br>  "cached_methods": [<br>    "GET",<br>    "HEAD"<br>  ],<br>  "compress": true,<br>  "viewer_protocol_policy": "redirect-to-https"<br>}</pre> | no |
| <a name="input_cloudfront_default_root_object"></a> [cloudfront\_default\_root\_object](#input\_cloudfront\_default\_root\_object) | Object that you want CloudFront to return when an end user requests the root URL. | `string` | `"index.html"` | no |
| <a name="input_cloudfront_distribution_tags"></a> [cloudfront\_distribution\_tags](#input\_cloudfront\_distribution\_tags) | n/a | `map(string)` | `null` | no |
| <a name="input_cloudfront_enabled"></a> [cloudfront\_enabled](#input\_cloudfront\_enabled) | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| <a name="input_cloudfront_geo_restriction"></a> [cloudfront\_geo\_restriction](#input\_cloudfront\_geo\_restriction) | Configuration for CloudFront to limit the distribution of your content geographically. Omit this to apply no restrictions. | <pre>object({<br>    locations        = list(string)<br>    restriction_type = string<br>  })</pre> | <pre>{<br>  "locations": [],<br>  "restriction_type": "none"<br>}</pre> | no |
| <a name="input_cloudfront_is_ipv6_enabled"></a> [cloudfront\_is\_ipv6\_enabled](#input\_cloudfront\_is\_ipv6\_enabled) | Whether IPv6 is enabled for the distribution. | `string` | `true` | no |
| <a name="input_cloudfront_logging_configuration"></a> [cloudfront\_logging\_configuration](#input\_cloudfront\_logging\_configuration) | Configuration to enable the Cloudfront distribution to write logs to an s3 bucket. | <pre>object({<br>    include_cookies = optional(bool)<br>    bucket_name     = string<br>    prefix          = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_cloudfront_price_class"></a> [cloudfront\_price\_class](#input\_cloudfront\_price\_class) | Price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `string` | `"PriceClass_200"` | no |
| <a name="input_cloudfront_s3_origin_id"></a> [cloudfront\_s3\_origin\_id](#input\_cloudfront\_s3\_origin\_id) | Unique identifier for the s3 origin within the cloudfront distribution. | `string` | `"DefaultS3Origin"` | no |
| <a name="input_cloudfront_viewer_certificate"></a> [cloudfront\_viewer\_certificate](#input\_cloudfront\_viewer\_certificate) | The SSL configuration for the cloudfront distribution. Omit this to use the cloudfront default certificate. | <pre>object({<br>    acm_certificate_arn      = string<br>    minimum_protocol_version = optional(string)<br>    ssl_support_method       = string<br>  })</pre> | `null` | no |
| <a name="input_origin_access_control_description"></a> [origin\_access\_control\_description](#input\_origin\_access\_control\_description) | The description of the Origin Access Control providing S3 origin access to cloudfront. | `string` | `"Origin Access Control for S3 Origin"` | no |
| <a name="input_origin_access_control_name"></a> [origin\_access\_control\_name](#input\_origin\_access\_control\_name) | A name that identifies the Origin Access Control providing S3 origin access to cloudfront. Defaults to the buckets `bucket_regional_domain_name`. | `string` | `null` | no |
| <a name="input_origin_access_control_signing_behavior"></a> [origin\_access\_control\_signing\_behavior](#input\_origin\_access\_control\_signing\_behavior) | Specifies which requests CloudFront signs. Allowed values: `always`, `never`, and `no-override`. | `string` | `"always"` | no |
| <a name="input_origin_bucket_force_destroy"></a> [origin\_bucket\_force\_destroy](#input\_origin\_bucket\_force\_destroy) | Boolean that indicates all objects should be deleted from the origin bucket when the bucket is destroyed through Terraform. | `bool` | `false` | no |
| <a name="input_origin_bucket_name"></a> [origin\_bucket\_name](#input\_origin\_bucket\_name) | Name of the origin bucket to be created | `string` | `null` | no |
| <a name="input_origin_bucket_tags"></a> [origin\_bucket\_tags](#input\_origin\_bucket\_tags) | Map of tags to assign to the origin bucket. | `map(string)` | `null` | no |
| <a name="input_origin_bucket_use_existing"></a> [origin\_bucket\_use\_existing](#input\_origin\_bucket\_use\_existing) | Output values of an s3 origin bucket if you wish to manage and create an origin bucket outside this module. | <pre>object({<br>    create_bucket_policy        = bool<br>    arn                         = string<br>    id                          = string<br>    bucket_regional_domain_name = string<br>  })</pre> | `null` | no |
| <a name="input_origin_bucket_versioning_status"></a> [origin\_bucket\_versioning\_status](#input\_origin\_bucket\_versioning\_status) | Versioning state of the origin bucket. Valid values: `Enabled`, `Suspended`, or `Disabled`. | `string` | `"Disabled"` | no |
| <a name="input_route53_create_records"></a> [route53\_create\_records](#input\_route53\_create\_records) | Boolean on whether to create route53 record(s) (simple alias record) for the cloudfront alias(es). | `bool` | `false` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The ID of the hosted zone to contain this record. | `string` | `null` | no |
<!-- END_TF_DOCS -->