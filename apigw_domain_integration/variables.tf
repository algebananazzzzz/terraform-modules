variable "apigw_api_id" {
  description = "Identifier for the API which stage belongs to."
  type        = string
}

variable "apigw_stage_id" {
  description = "Identifier for the stage to map domain name to."
  type        = string
}

variable "domain_name" {
  description = "Custom Domain name which is a subdomain to the domain of the hosted zone provided in `zone_id`."
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone id to create a record for your provided domain name."
  type        = string
}

variable "regional_certificate_arn" {
  description = "ARN of an AWS-managed certificate that will be used by the endpoint for the domain name."
  type        = string
}

variable "ownership_verification_certificate_arn" {
  description = "ARN of the AWS-issued certificate used to validate custom domain ownership."
  type        = string
  default     = null
}

variable "mutual_tls_authentication" {
  description = "Mutual TLS authentication configuration for the domain name."
  type = object({
    truststore_uri     = string
    truststore_version = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Map of tags to assign to apigw domain name resource."
  type        = map(string)
  default     = null
}
