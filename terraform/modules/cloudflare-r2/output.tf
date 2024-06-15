output "endpoint" {
  value = "${var.account_id}.r2.cloudflarestorage.com"
}

output "access_key" {
  value = cloudflare_api_token.gotosocial_media.id
}

output "secret_key" {
  value = sha256(cloudflare_api_token.gotosocial_media.value)
}
