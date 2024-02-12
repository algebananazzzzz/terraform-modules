resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name = coalesce(
    var.origin_access_control_name,
    local.create_new_bucket ? aws_s3_bucket.new[0].bucket_regional_domain_name : null,
    try(var.origin_bucket_use_existing.bucket_regional_domain_name, "S3Origin")
  )
  description                       = var.origin_access_control_description
  origin_access_control_origin_type = "s3"
  signing_behavior                  = var.origin_access_control_signing_behavior
  signing_protocol                  = "sigv4"
}
