output "cloudflare_tunnel_token" {
  value     = cloudflare_tunnel.gotosocial_tunnel.tunnel_token
  sensitive = true
}

output "gts_host" {
  value = "${cloudflare_record.gotosocial_tunnel.name}.${data.cloudflare_zone.target_zone.name}"
}

output "gts_db_address" {
  value = module.aws_lightsail_database.db_address
}

output "gts_db_password" {
  value     = module.aws_lightsail_database.db_password
  sensitive = true
}

output "gts_storage_s3_endpoint" {
  value = module.aws_s3.endpoint
}

output "gts_storage_s3_access_key" {
  value = module.aws_s3.access_key
}

output "gts_storage_s3_secret_key" {
  value     = module.aws_s3.secret_key
  sensitive = true
}
