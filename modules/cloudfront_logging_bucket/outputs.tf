output "bucket_name" {
  value = aws_s3_bucket.log_bucket.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.log_bucket.id
}
