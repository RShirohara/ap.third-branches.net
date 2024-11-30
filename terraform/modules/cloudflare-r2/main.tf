terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.47.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_r2_bucket" "gotosocial_media" {
  account_id = var.account_id
  name       = "gotosocial-media"
  location   = var.location
}

resource "cloudflare_api_token" "gotosocial_media" {
  name = "gotosocial-media"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.r2["Workers R2 Storage Bucket Item Read"],
      data.cloudflare_api_token_permission_groups.all.r2["Workers R2 Storage Bucket Item Write"]
    ]

    resources = {
      "com.cloudflare.edge.r2.bucket.${var.account_id}_default_${cloudflare_r2_bucket.gotosocial_media.id}" = "*"
    }
  }

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.account["Workers R2 Storage Read"]
    ]

    resources = {
      "com.cloudflare.api.account.${var.account_id}" = "*"
    }
  }
}

data "cloudflare_api_token_permission_groups" "all" {}
