AWS Static Site Terraform module
========================

Terraform module which creates a fully functional static site based in S3 and CloudFront

Usage
-----

```hcl
module "static-site" {
  source                  = "git::https://github.com/egarbi/terraform-aws-static-site"
  site_domain             = "example.com"
  site_name               = "" // Empty string means top level domain
  artifact_dir            = "${path.module}/dist/"
}
```
