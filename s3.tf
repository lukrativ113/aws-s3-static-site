resource "aws_s3_bucket" "main" {
  bucket = local.site_fqdn_safe
  policy = "${data.aws_iam_policy_document.s3_policy.json}"

  acl = "private"

  tags = var.extra_tags
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/${var.artifact_dir}"
}

resource "aws_s3_bucket_object" "static_files" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.main.id
  key          = each.key
  content_type = each.value.content_type

  # The template_files module guarantees that only one of these two attributes
  # will be set for each file, depending on whether it is an in-memory template
  # rendering result or a static file on disk.
  source  = each.value.source_path
  content = each.value.content

  # Unless the bucket has encryption enabled, the ETag of each object is an
  # MD5 hash of that object.
  etag = each.value.digests.md5

  depends_on = [
    aws_s3_bucket.main.id
  ]
}
