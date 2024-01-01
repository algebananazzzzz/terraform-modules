locals {
  origin_bucket_name         = "website_bucket"
  origin_access_control_name = "website_bucket.s3origin"
  log_bucket_name            = "cloudfront_logs"
}

module "cloudfront_log_bucket" {
  source          = "./modules/cloudfront_logging_bucket"
  log_bucket_name = local.log_bucket_name
}

module "cloudfront_s3_website" {
  source                     = "../modules/cloudfront_s3"
  origin_bucket_name         = local.origin_bucket_name
  origin_access_control_name = local.origin_access_control_name
  cloudfront_logging_configuration = [{
    bucket_name = module.cloudfront_log_bucket.bucket_name
  }]
  # cloudfront_aliases = ["alias.origin.com"]
  # cloudfront_viewer_certificate = {
  #   acm_certificate_arn = "certificate_arn"
  # }
}

# resource "aws_route53_record" "www" {
#   zone_id = "zone_id"
#   name    = "example.origin.com"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.s3_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
