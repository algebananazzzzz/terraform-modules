
resource "aws_s3_bucket" "origin_bucket" {
  bucket        = var.origin_bucket_name
  force_destroy = var.origin_bucket_force_destroy
  tags          = var.origin_bucket_tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.origin_bucket.id

  versioning_configuration {
    status = var.origin_bucket_versioning
  }
}
