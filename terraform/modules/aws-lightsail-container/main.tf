terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }
}

resource "aws_lightsail_container_service" "gotosocial_service" {
  name  = "gotosocial-service"
  power = var.power
  scale = var.scale

  tags = {
    service = "gotosocial"
  }
}

resource "aws_lightsail_container_service_deployment_version" "gotosocial_container" {
  service_name = aws_lightsail_container_service.gotosocial_service.name

  container {
    container_name = "app"
    image          = "superseriousbusiness/gotosocial:0.19.0"

    environment = {
      SERVICE_CON                          = "service://localhost"
      TZ                                   = "Asia/Tokyo"
      GTS_HOST                             = var.app_host
      GTS_PORT                             = "8080"
      GTS_DB_TYPE                          = "postgres"
      GTS_DB_ADDRESS                       = var.app_db_address
      GTS_DB_USER                          = "gotosocial"
      GTS_DB_PASSWORD                      = var.app_db_password
      GTS_DB_DATABASE                      = "gotosocial"
      GTS_DB_TLS_MODE                      = "enable"
      GTS_ACCOUNTS_REGISTRATION_OPEN       = "false"
      GTS_STORAGE_BACKEND                  = "s3"
      GTS_STORAGE_S3_ENDPOINT              = var.app_s3_endpoint
      GTS_STORAGE_S3_ACCESS_KEY            = var.app_s3_access_key
      GTS_STORAGE_S3_SECRET_KEY            = var.app_s3_secret_key
      GTS_STORAGE_S3_BUCKET                = "gotosocial-media"
      GTS_LETSENCRYPT_ENABLED              = "false"
      GTS_INSTANCE_INJECT_MASTODON_VERSION = "true"
    }
  }

  container {
    container_name = "tunnel"
    image          = "cloudflare/cloudflared:2025.4.2"

    command = ["tunnel", "run"]

    environment = {
      SERVICE_CON  = "service://localhost"
      TUNNEL_TOKEN = var.tunnel_token
    }
  }
}
