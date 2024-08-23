locals {
  site_fqdn          = "${var.site_name}.${var.site_domain}"
  site_fqdn_safe     = replace(local.site_fqdn, ".", "-")

  acm_sans_list   = var.site_name == "www" ? [var.site_domain] : []
  cf_aliases_list = var.site_name == "www" ? [local.site_fqdn, var.site_domain] : [local.site_fqdn]

  lambda_function_name    = "${local.site_fqdn_safe}-lambda-edge-rewrite"
  lambda_function_payload = "${path.module}/lambda_payload.zip"
}
