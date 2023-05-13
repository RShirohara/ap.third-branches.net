variable "cloudflare_api_token" {
  type        = string
  description = "The API Token for opetarions to cloudflare."
}

variable "cloudflare_account_id" {
  type        = string
  description = "The cloudflare account identifier to target for the resource."
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The cloudflare zone identifier to target for the resource."
}

variable "cloudflare_record_name" {
  type        = string
  description = "The name of the cloudflare DNS record."
}
