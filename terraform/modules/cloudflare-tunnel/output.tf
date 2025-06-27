
output "cname" {
  value = "${cloudflare_zero_trust_tunnel_cloudflared.gotosocial_tunnel.id}.cfargotunnel.com"
}

output "token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.gotosocial_tunnel.token
  sensitive = true
}
