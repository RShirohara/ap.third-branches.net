terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21.0"
    }
  }
}

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

resource "aws_iam_user" "gotosocial_bucket_manager" {
  name = "gotosocial-bucket-manager"

  tags = {
    service = "gotosocial"
  }
}

resource "aws_iam_access_key" "gotosocial_bucket_manager" {
  user = aws_iam_user.gotosocial_bucket_manager.name
}

resource "aws_iam_policy" "gotosocial_bucket_management" {
  name   = "gotosocial-bucket-management"
  policy = data.aws_iam_policy_document.gotosocial_bucket_management.json

  tags = {
    service = "gotosocial"
  }
}

data "aws_iam_policy_document" "gotosocial_bucket_management" {
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

resource "aws_iam_policy_attachment" "gotosocial_bucket_manage" {
  name       = "gotosocial-bucket-manage"
  users      = [aws_iam_user.gotosocial_bucket_manager.name]
  policy_arn = aws_iam_policy.gotosocial_bucket_management.arn
}
