locals {
  site_fqdn_combined = "${var.site_name}.${var.domain}"
}

locals {
  site_fqdn = local.site_fqdn_combined
  site_fqdn_safe = replace(local.site_fqdn_combined, ".", "-")
}


resource "aws_s3_bucket_policy" "s3_policy_main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.s3_policy.json
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

resource "aws_s3_bucket" "main" {
  bucket = local.site_fqdn_safe
  policy = "${data.aws_iam_policy_document.s3_policy.json}"

  acl = "private"

  tags = var.extra_tags
}

# Add record on DNS for minion instance
resource "aws_route53_record" "site_root" {
  count   = var.site_name == "www" ? 0 : 1
  zone_id = "${var.public_dns_zone}"
  name    = var.domain
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "site" {
  zone_id = "${var.public_dns_zone}"
  name    = local.site_fqdn
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}

output "bucket" {
  value = "${aws_s3_bucket.main.id}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.main.arn}"
}
