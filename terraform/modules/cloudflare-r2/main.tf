terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.4.0"
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

  # WORKAROUND: <https://github.com/cloudflare/terraform-provider-cloudflare/issues/5062#issuecomment-2749703161>
  policies = [
    {
      effect = "allow"
      permission_groups = [
        {
          id = element(
            data.cloudflare_api_token_permission_groups_list.all.result,
            index(
              data.cloudflare_api_token_permission_groups_list.all.result.*.name,
              "Workers R2 Storage Bucket Item Read"
            )
          ).id,
        },
        {
          id = element(
            data.cloudflare_api_token_permission_groups_list.all.result,
            index(
              data.cloudflare_api_token_permission_groups_list.all.result.*.name,
              "Workers R2 Storage Bucket Item Write"
            )
          ).id
        },
      ]
      resources = {
        "com.cloudflare.edge.r2.bucket.${var.account_id}_default_${cloudflare_r2_bucket.gotosocial_media.id}" = "*"
      }
    },
    {
      effect = "allow"
      permission_groups = [
        {
          id = element(
            data.cloudflare_api_token_permission_groups_list.all.result,
            index(
              data.cloudflare_api_token_permission_groups_list.all.result.*.name,
              "Workers R2 Storage Read"
            )
          ).id
        }
      ]
      resources = {
        "com.cloudflare.api.account.${var.account_id}" = "*"
      }
    }
  ]
}

data "cloudflare_api_token_permission_groups_list" "all" {}
