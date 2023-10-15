output "db_address" {
  value = aws_lightsail_database.gotosocial_db.master_endpoint_address
}

output "db_password" {
  value     = aws_lightsail_database.gotosocial_db.master_password
  sensitive = true
}
