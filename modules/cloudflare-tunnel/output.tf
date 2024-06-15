
output "cname" {
  value = cloudflare_tunnel.gotosocial_tunnel.cname
}

output "token" {
  value     = cloudflare_tunnel.gotosocial_tunnel.tunnel_token
  sensitive = true
}
