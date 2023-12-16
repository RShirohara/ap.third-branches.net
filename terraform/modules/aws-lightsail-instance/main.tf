terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

resource "aws_lightsail_instance" "gotosocial_app" {
  name              = "gotosocial-app"
  availability_zone = data.aws_availability_zones.availability_zone.names[0]
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id

  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "18:00"
    status        = "Enabled"
  }

  tags = {
    service = "gotosocial"
  }
}

data "aws_availability_zones" "availability_zone" {
  state = "available"
}
