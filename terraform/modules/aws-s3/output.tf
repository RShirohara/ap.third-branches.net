output "endpoint" {
  value = replace(aws_s3_bucket.gotosocial_bucket.bucket_regional_domain_name, "${aws_s3_bucket.gotosocial_bucket.bucket}.", "")
}

output "access_key" {
  value = aws_iam_access_key.gotosocial_bucket_manager.id
}

output "secret_key" {
  value     = aws_iam_access_key.gotosocial_bucket_manager.secret
  sensitive = true
}
