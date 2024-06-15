terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.35.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# App instance
module "aws_lightsail_instance" {
  source = "./modules/aws-lightsail-instance"
}

moved {
  from = aws_lightsail_instance.gotosocial_app
  to   = module.aws_lightsail_instance.aws_lightsail_instance.gotosocial_app
}

# App container
module "aws_lightsail_container" {
  source = "./modules/aws-lightsail-container"

  app_host          = module.cloudflare_zone.origin
  app_db_address    = module.aws_lightsail_database.db_address
  app_db_password   = module.aws_lightsail_database.db_password
  app_s3_endpoint   = module.cloudflare_r2.endpoint
  app_s3_access_key = module.cloudflare_r2.access_key
  app_s3_secret_key = module.cloudflare_r2.secret_key
  tunnel_token      = module.cloudflare_tunnel.token
}

# DB Instance
module "aws_lightsail_database" {
  source = "./modules/aws-lightsail-db"
}

moved {
  from = aws_lightsail_database.gotosocial_db
  to   = module.aws_lightsail_database.aws_lightsail_database.gotosocial_db
}

moved {
  from = random_password.lightsail_db_password
  to   = module.aws_lightsail_database.random_password.db_password
}

moved {
  from = random_string.lightsail_db_snapshot
  to   = module.aws_lightsail_database.random_string.db_snapshot
}

# Media bucket
module "cloudflare_r2" {
  source = "./modules/cloudflare-r2"

  api_token  = var.cloudflare_api_token
  account_id = var.cloudflare_account_id
}

# Reverse proxy
module "cloudflare_tunnel" {
  source = "./modules/cloudflare-tunnel"

  api_token  = var.cloudflare_api_token
  account_id = var.cloudflare_account_id
  origin     = module.cloudflare_zone.origin
}

moved {
  from = cloudflare_tunnel.gotosocial_tunnel
  to   = module.cloudflare_tunnel.cloudflare_tunnel.gotosocial_tunnel
}

moved {
  from = cloudflare_tunnel_config.gotosocial_tunnel
  to   = module.cloudflare_tunnel.cloudflare_tunnel_config.gotosocial_tunnel
}

moved {
  from = random_id.clooudflare_tunnel_secret
  to   = module.cloudflare_tunnel.random_id.tunnel_secret
}

# DNS Record
module "cloudflare_zone" {
  source = "./modules/cloudflare-zone"

  api_token    = var.cloudflare_api_token
  record_name  = var.cloudflare_record_name
  record_value = module.cloudflare_tunnel.cname
  zone_id      = var.cloudflare_zone_id
}

moved {
  from = cloudflare_record.gotosocial_tunnel
  to   = module.cloudflare_zone.cloudflare_record.gotosocial_domain
}
