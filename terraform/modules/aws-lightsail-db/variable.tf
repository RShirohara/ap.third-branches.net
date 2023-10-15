variable "blueprint_id" {
  type        = string
  description = "The blueprint ID for database."
  default     = "postgres_15"
}

variable "bundle_id" {
  type        = string
  description = "The bundle ID for database."
  default     = "micro_2_0"
}
