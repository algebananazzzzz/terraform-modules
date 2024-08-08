output "distribution" {
  description = "An object representing the created `aws_cloudfront_distribution` resource."
  value       = aws_cloudfront_distribution.this
}

output "domain_name" {
  value = var.cloudfront_aliases != null ? aws_route53_record.aliases[0] : aws_cloudfront_distribution.this.domain_name
}

output "origin_access_control" {
  description = "An object representing the created `aws_cloudfront_origin_access_control` resource."
  value       = aws_cloudfront_origin_access_control.origin_access_control
}

output "records" {
  description = "A list of objects representing the list of created `aws_route53_record` resources."
  value       = aws_route53_record.aliases
}

output "new_bucket" {
  description = "An object representing the created `aws_lambda_permission` resource. Returns null if `origin_bucket_use_existing` is set."
  value       = local.create_new_bucket ? aws_s3_bucket.new[0] : null
}

output "bucket_permission" {
  description = "An object representing the created `aws_s3_bucket_policy` resource. Returns null if `create_bucket_policy` is set to false."
  value       = local.create_bucket_policy ? aws_s3_bucket_policy.this[0] : null
}
