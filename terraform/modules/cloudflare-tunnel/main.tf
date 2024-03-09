terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_tunnel" "gotosocial_tunnel" {
  account_id = var.account_id
  name       = "gotosocial"
  secret     = random_id.tunnel_secret.b64_std
}

resource "cloudflare_tunnel_config" "gotosocial_tunnel" {
  account_id = var.account_id
  tunnel_id  = cloudflare_tunnel.gotosocial_tunnel.id

  config {
    ingress_rule {
      hostname = var.origin
      service  = "http://app:8080"
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "random_id" "tunnel_secret" {
  byte_length = 35
}
