output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "distribution_origin" {
  value = aws_cloudfront_distribution.s3_distribution.origin
}

output "distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
