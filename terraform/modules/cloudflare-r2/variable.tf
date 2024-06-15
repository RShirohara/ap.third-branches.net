variable "api_token" {
  type        = string
  description = "The API Token for operations to cloudflare."
}

variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource."
}

variable "location" {
  type        = string
  description = "The location hint of the R2 bucket."
  default     = "APAC"
}
