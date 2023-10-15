variable "blueprint_id" {
  type        = string
  description = "The ID for a virtual private server image."
  default     = "centos_stream_9"
}

variable "bundle_id" {
  type        = string
  description = "The bundle of specification information."
  default     = "micro_2_0"
}
