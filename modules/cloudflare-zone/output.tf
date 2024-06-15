output "origin" {
  value = "${var.record_name}.${data.cloudflare_zone.target_zone.name}"
}
