data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/lambda/edge_rewrite/rewrite.js"
  output_path = local.lambda_function_payload
}

// Global Content Delivery Network
// S3 + Cloudfront
// Content of this bucket will be populated manually
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.site_fqdn_safe}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.site_fqdn_safe}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}
