locals {
  site_fqdn          = "${var.site_subdomain}.${var.site_domain}"
  site_fqdn_combined = "${var.site_name}.${var.site_domain}"
  site_fqdn          = local.site_fqdn_combined
  site_fqdn_safe     = replace(local.site_fqdn_combined, ".", "-")

  acm_sans_list   = var.site_name == "www" ? [var.site_domain] : []0
  cf_aliases_list = var.site_name == "www" ? [local.site_fqdn, var.site_domain] : [local.site_fqdn]

  lambda_function_name    = "${local.site_fqdn_safe}-lambda-edge-rewrite"
  lambda_function_payload = "${path.module}/lambda_payload.zip"
}
