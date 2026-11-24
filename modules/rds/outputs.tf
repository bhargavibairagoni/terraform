output "db_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "Connection endpoint for PostgreSQL"
}

output "db_address" {
  value       = aws_db_instance.postgres.address
  description = "Hostname of the database"
}

output "db_name" {
  value       = aws_db_instance.postgres.db_name
  description = "Database name"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "ARN of AWS Secrets Manager secret storing DB credentials"
}

