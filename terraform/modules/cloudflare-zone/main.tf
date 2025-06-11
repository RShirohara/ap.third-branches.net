terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_record" "gotosocial_domain" {
  name    = var.record_name
  type    = "CNAME"
  zone_id = var.zone_id
  content = var.record_value
  proxied = true
}

data "cloudflare_zone" "target_zone" {
  zone_id = var.zone_id
}
