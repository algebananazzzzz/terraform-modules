variable "log_bucket_name" {
  type = string
}

variable "log_bucket_tags" {
  type    = map(string)
  default = null
}

variable "log_bucket_force_destroy" {
  type    = bool
  default = null
}
