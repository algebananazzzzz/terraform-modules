resource "aws_s3_object" "s3_deployment" {
  count       = var.deployment_package.s3_create_object_from_local != null ? 1 : 0
  bucket      = var.deployment_package.s3_bucket
  key         = var.deployment_package.s3_key
  source      = var.deployment_package.s3_create_object_from_local.local_path
  source_hash = filemd5(var.deployment_package.s3_create_object_from_local.local_path)
}
