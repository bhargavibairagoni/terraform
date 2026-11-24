# Multi-Region Primary KMS Key (Created in Primary Region: ap-south-1 Mumbai)
resource "aws_kms_key" "primary" {
  description             = "${var.project_name}-${var.environment}-primary-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  multi_region            = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-kms"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_kms_alias" "primary" {
  name          = "alias/${var.project_name}-${var.environment}"
  target_key_id = aws_kms_key.primary.key_id
}
