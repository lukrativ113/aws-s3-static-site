variable "artifact_dir" {
  type        = string
  description = "Local directory that contains the static site files"
  default     = "./dist"
}

variable "site_domain" {
  type        = string
  description = "Site domain name"
}

variable "site_name" {
  type        = string
  description = "Site name, used for subdomain"
}

variable "ssl_cert" {
  default = ""
}

variable "error_response_code" {
  default = "404"
}

variable "error_response_pagepath" {
  default = "/404.html"
}

variable "web_acl_id" {
  default = ""
}

variable "extra_tags" {
  type        = map(string)
  description = "Map of extra tags to provide each resource"
}
