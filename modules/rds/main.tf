# Random master password stored securely in AWS Secrets Manager
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}-${var.environment}-db-credentials"
  recovery_window_in_days = 0
  kms_key_id              = var.kms_key_arn != "" ? var.kms_key_arn : null

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    username = var.db_username
    password = random_password.db_password.result
    database = var.db_name
  })
}

# PostgreSQL Database (Multi-AZ with Point-In-Time Recovery PITR)
resource "aws_db_instance" "postgres" {
  identifier                 = "${var.project_name}-${var.environment}-pg"
  engine                     = "postgres"
  engine_version             = var.engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = random_password.db_password.result
  db_subnet_group_name       = var.db_subnet_group_name
  vpc_security_group_ids     = [var.rds_security_group_id]
  multi_az                   = var.multi_az
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  # KMS Storage Encryption
  storage_encrypted = true
  kms_key_id        = var.kms_key_arn != "" ? var.kms_key_arn : null

  # Point-in-time recovery (PITR) & automated backups
  backup_retention_period   = var.backup_retention_period
  backup_window             = "19:00-20:00" # UTC (~00:30-01:30 IST)
  maintenance_window        = "Sun:20:00-Sun:21:00"
  copy_tags_to_snapshot     = true
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.environment == "prod" ? false : true
  final_snapshot_identifier = var.environment == "prod" ? "${var.project_name}-${var.environment}-final-snapshot" : null

  # Observability - Export logs to CloudWatch
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
