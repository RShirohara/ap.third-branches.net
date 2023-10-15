variable "api_token" {
  type        = string
  description = "The API Token for operations to cloudflare."
}

variable "record_name" {
  type        = string
  description = "The name of the record."
}

variable "record_value" {
  type        = string
  description = "The value of the record."
}

variable "zone_id" {
  type        = string
  description = "The zone identifier to target for the resource."
}
