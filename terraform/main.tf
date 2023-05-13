terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65"
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
resource "aws_lightsail_instance" "gotosocial_app" {
  name              = "gotosocial-app"
  availability_zone = data.aws_availability_zones.availability_zone.names[0]
  blueprint_id      = "centos_stream_9"
  bundle_id         = "micro_2_0"
  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "18:00"
    status        = "Enabled"
  }
  tags = {
    service = "gotosocial"
  }
}

## Lightsail DB
resource "aws_lightsail_database" "gotosocial_db" {
  relational_database_name = "gotosocial-db"
  availability_zone        = data.aws_availability_zones.availability_zone.names[0]
  master_database_name     = "gotosocial"
  master_username          = "gotosocial"
  master_password          = random_password.lightsail_db_password.result
  blueprint_id             = "postgres_15"
  bundle_id                = "micro_2_0"
  final_snapshot_name      = "gotosocial-db-delete-${random_string.lightsail_db_snapshot.id}"
  tags = {
    service = "gotosocial"
  }
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

## Data resource
data "aws_availability_zones" "availability_zone" {
  state = "available"
}

resource "random_password" "lightsail_db_password" {
  length  = 64
  special = false
}

resource "random_string" "lightsail_db_snapshot" {
  length  = 8
  special = false
  upper   = false
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
