variable "domain_name" {
  type = string
}

variable "regional_certificate_arn" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "api_mappings" {
  type = map(object({
    api_id   = string
    stage_id = string
  }))
}
