output "cloudflare_tunnel_token" {
  value     = module.cloudflare_tunnel.token
  sensitive = true
}

output "gts_host" {
  value = module.cloudflare_dns.origin
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
