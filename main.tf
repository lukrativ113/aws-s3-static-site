resource "aws_s3_bucket_policy" "s3_policy_main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# Add record on DNS for minion instance
resource "aws_route53_record" "site_root" {
  count   = var.site_name != "www" ? 0 : 1
  zone_id = data.aws_route53_zone.hz.id
  name    = var.site_domain
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.hz.id
  name    = local.site_fqdn
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}
