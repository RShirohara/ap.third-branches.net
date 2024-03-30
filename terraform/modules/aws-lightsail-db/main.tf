terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }
}

resource "aws_lightsail_database" "gotosocial_db" {
  relational_database_name = "gotosocial-db"
  availability_zone        = data.aws_availability_zones.availability_zone.names[0]
  master_database_name     = "gotosocial"
  master_username          = "gotosocial"
  master_password          = random_password.db_password.result
  blueprint_id             = var.blueprint_id
  bundle_id                = var.bundle_id
  preferred_backup_window  = "18:00-19:00"
  backup_retention_enabled = true
  final_snapshot_name      = "gotosocial-db-delete-${random_string.db_snapshot.id}"

  tags = {
    service = "gotosocial"
  }
}

resource "random_password" "db_password" {
  length  = 64
  special = false
}

resource "random_string" "db_snapshot" {
  length  = 8
  special = false
  upper   = false
}

data "aws_availability_zones" "availability_zone" {
  state = "available"
}
