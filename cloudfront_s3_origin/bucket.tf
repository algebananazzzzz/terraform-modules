locals {
  create_new_bucket = var.origin_bucket_use_existing == null
}

check "s3_bucket_variables" {
  assert {
    condition = anytrue([
      !local.create_new_bucket,
      var.origin_bucket_name != null,
    ])
    error_message = "`origin_bucket_name` is not specified even when `origin_use_existing_bucket` is not specified."
  }
}

resource "aws_s3_bucket" "new" {
  count         = local.create_new_bucket ? 1 : 0
  bucket        = var.origin_bucket_name
  force_destroy = var.origin_bucket_force_destroy
  tags          = var.origin_bucket_tags
}

resource "aws_s3_bucket_versioning" "create_new" {
  count  = local.create_new_bucket ? 1 : 0
  bucket = aws_s3_bucket.new[0].id

  versioning_configuration {
    status = var.origin_bucket_versioning_status
  }
}
