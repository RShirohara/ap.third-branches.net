variable "cloudflare_api_token" {
  type        = string
  description = "The API Token for operations to cloudflare."
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

variable "cloudflare_terraform_backend_access_key" {
  type        = string
  description = "The cloudflare r2 access key used to save tfstate in storage."
}

variable "cloudflare_terraform_backend_access_secret" {
  type        = string
  description = "The cloudflare r2 secret key used to save tfstate in storage."
}
