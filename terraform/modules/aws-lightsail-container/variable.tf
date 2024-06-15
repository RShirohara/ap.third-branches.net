variable "power" {
  type        = string
  description = "The power specification for the container service."
  default     = "nano"
}

variable "scale" {
  type        = number
  description = "The scale specification for container service."
  default     = 1
}

variable "app_host" {
  type = string
}

variable "app_db_address" {
  type = string
}

variable "app_db_password" {
  type = string
  sensitive = true
}

variable "app_s3_endpoint" {
  type = string
}

variable "app_s3_access_key" {
  type = string
}

variable "app_s3_secret_key" {
  type = string
  sensitive = true
}

variable "tunnel_token" {
  type = string
  sensitive = true
}
