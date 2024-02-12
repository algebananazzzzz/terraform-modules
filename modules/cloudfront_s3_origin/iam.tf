locals {
  create_bucket_policy = anytrue([
    local.create_new_bucket,
    try(var.origin_bucket_use_existing.create_bucket_policy, false)
  ])

  existing_s3_bucket_arns = alltrue([
    local.create_bucket_policy,
    !local.create_new_bucket
    ]) ? [
    var.origin_bucket_use_existing.arn,
    "${var.origin_bucket_use_existing.arn}/*"
  ] : null
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "AllowCloudfrontOriginAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = local.existing_s3_bucket_arns != null ? local.existing_s3_bucket_arns : [
      aws_s3_bucket.new[0].arn,
      "${aws_s3_bucket.new[0].arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = local.create_bucket_policy ? 1 : 0
  bucket = local.create_new_bucket ? aws_s3_bucket.new[0].id : var.origin_bucket_use_existing.id
  policy = data.aws_iam_policy_document.policy.json
}
