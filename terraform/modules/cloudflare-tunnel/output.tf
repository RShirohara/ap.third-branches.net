
output "cname" {
  value = cloudflare_zero_trust_tunnel_cloudflared.gotosocial_tunnel.cname
}

output "token" {
  value     = cloudflare_zero_trust_tunnel_cloudflared.gotosocial_tunnel.tunnel_token
  sensitive = true
}
