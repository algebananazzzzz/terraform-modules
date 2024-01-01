
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "AllowCloudfrontOriginAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.origin_bucket.arn,
      "${aws_s3_bucket.origin_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.origin_bucket.id
  policy = data.aws_iam_policy_document.policy.json
}
