# Terraform backend
terraform {
  backend "s3" {
    bucket                      = "terraform-tfstate"
    key                         = "ap.third-branches.net/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    access_key = var.cloudflare_terraform_backend_access_key
    secret_key = var.cloudflare_terraform_backend_access_secret
    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }
  }
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

# DNS Record
module "cloudflare_zone" {
  source = "./modules/cloudflare-zone"

  api_token    = var.cloudflare_api_token
  record_name  = var.cloudflare_record_name
  record_value = module.cloudflare_tunnel.cname
  zone_id      = var.cloudflare_zone_id
}
