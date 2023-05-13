output "cloudflare_tunnel_token" {
  value     = cloudflare_tunnel.gotosocial_tunnel.tunnel_token
  sensitive = true
}

output "gts_host" {
  value = "${cloudflare_record.gotosocial_tunnel.name}.${data.cloudflare_zone.target_zone.name}"
}

output "gts_db_password" {
  value     = aws_lightsail_database.gotosocial_db.master_password
  sensitive = true
}

output "gts_storage_s3_endpoint" {
  value = aws_s3_bucket.gotosocial_bucket.bucket_regional_domain_name
}

output "gts_storage_s3_access_key" {
  value = aws_iam_access_key.gotosocial_bucket.id
}

output "gts_storage_s3_secret_key" {
  value     = aws_iam_access_key.gotosocial_bucket.secret
  sensitive = true
}
