terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "gotosocial_tunnel" {
  account_id    = var.account_id
  name          = "gotosocial"
  tunnel_secret = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "gotosocial_tunnel" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.gotosocial_tunnel.id

  config = {
    ingress = [
      {
        hostname = var.origin
        service  = "http://localhost:8080"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "random_id" "tunnel_secret" {
  byte_length = 35
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "gotosocial_tunnel" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.gotosocial_tunnel.id
}
