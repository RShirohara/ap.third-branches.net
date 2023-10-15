terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# AWS Resouces
## Lightsail Instance
module "aws_lightsail_instance" {
  source = "./modules/aws-lightsail-instance"
}

moved {
  from = aws_lightsail_instance.gotosocial_app
  to   = module.aws_lightsail_instance.aws_lightsail_instance.gotosocial_app
}

## Lightsail DB
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

## S3 Bucket
resource "aws_s3_bucket" "gotosocial_bucket" {
  bucket = "gotosocial-bucket"
  tags = {
    service = "gotosocial"
  }
}

resource "aws_s3_bucket_versioning" "gotosocial_bucket" {
  bucket = aws_s3_bucket.gotosocial_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_iam_user" "gotosocial_bucket" {
  name = "gotosocial-bucket-manager"
  tags = {
    service = "gotosocial"
  }
}

resource "aws_iam_access_key" "gotosocial_bucket" {
  user = aws_iam_user.gotosocial_bucket.name
}

resource "aws_iam_policy" "gotosocial_bucket" {
  name   = "gotosocial-bucket-management"
  policy = data.aws_iam_policy_document.gotosocial_bucket.json
  tags = {
    service = "gotosocial"
  }
}

resource "aws_iam_policy_attachment" "gotosocial_bucket" {
  name       = "gotosocial-bucket-manage"
  users      = [aws_iam_user.gotosocial_bucket.name]
  policy_arn = aws_iam_policy.gotosocial_bucket.arn
}

data "aws_iam_policy_document" "gotosocial_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["awr:aws:s3:::*"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.gotosocial_bucket.arn,
      "${aws_s3_bucket.gotosocial_bucket.arn}/*"
    ]
  }
}

# Cloudflare Resources
## Tunnel
resource "cloudflare_tunnel" "gotosocial_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "gotosocial"
  secret     = random_id.clooudflare_tunnel_secret.b64_std
}

resource "cloudflare_tunnel_config" "gotosocial_tunnel" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.gotosocial_tunnel.id
  config {
    ingress_rule {
      hostname = "${var.cloudflare_record_name}.${data.cloudflare_zone.target_zone.name}"
      service  = "http://app:8080"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

## DNS Record
resource "cloudflare_record" "gotosocial_tunnel" {
  name    = var.cloudflare_record_name
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
  value   = "${cloudflare_tunnel.gotosocial_tunnel.id}.cfargotunnel.com"
  proxied = true
}

## Data resource
data "cloudflare_zone" "target_zone" {
  zone_id = var.cloudflare_zone_id
}

resource "random_id" "clooudflare_tunnel_secret" {
  byte_length = 35
}
