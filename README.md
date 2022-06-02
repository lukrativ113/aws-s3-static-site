AWS Static Site Terraform module
========================

Terraform module which creates a fully functional static site based in S3 and CloudFront

Usage
-----

```hcl
module "static-site" {
  source                  = "git::https://github.com/egarbi/terraform-aws-static-site"
  domain                  = "example.com"
  site_name               = "" // Empty string means top level domain
  public_dns_zone         = "Z3XXXXXQLNTSW2" 
  acm_certificate_arn     = "arn:aws:acm:us-east-1:1234567890:certificate/12345678-cf12-2fbc-1qc0-0399ac0dd123" 
}
```
