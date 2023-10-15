variable "api_token" {
  type        = string
  description = "The API Token for operations to cloudflare."
}

variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource."
}

variable "origin" {
  type        = string
  description = "The origin-url for the domain."
}
