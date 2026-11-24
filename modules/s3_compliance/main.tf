# S3 Bucket for Statutory Evidence with Object Lock (Governance Mode)
resource "aws_s3_bucket" "evidence" {
  bucket              = "${var.project_name}-${var.environment}-statutory-evidence"
  object_lock_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-statutory-evidence"
    Environment = var.environment
    Compliance  = "Statutory-EPFO-ESIC-ContractLabour"
    ManagedBy   = "Terraform"
  }
}

# Versioning is mandatory for Object Lock and Cross-Region Replication
resource "aws_s3_bucket_versioning" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Object Lock Configuration in GOVERNANCE mode
resource "aws_s3_bucket_object_lock_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.retention_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.evidence]
}

# Server-Side Encryption with KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Block all public access strictly
resource "aws_s3_bucket_public_access_block" "evidence" {
  bucket                  = aws_s3_bucket.evidence.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Cross-Region Replication (CRR) IAM Role
resource "aws_iam_role" "replication" {
  count = var.enable_replication && var.replica_bucket_arn != "" ? 1 : 0
  name  = "${var.project_name}-${var.environment}-s3-crr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  count = var.enable_replication && var.replica_bucket_arn != "" ? 1 : 0
  name  = "${var.project_name}-${var.environment}-s3-crr-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.evidence.arn]
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.evidence.arn}/*"]
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Effect   = "Allow"
        Resource = ["${var.replica_bucket_arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  count      = var.enable_replication && var.replica_bucket_arn != "" ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}

resource "aws_s3_bucket_replication_configuration" "evidence" {
  count      = var.enable_replication && var.replica_bucket_arn != "" ? 1 : 0
  bucket     = aws_s3_bucket.evidence.id
  role       = aws_iam_role.replication[0].arn
  depends_on = [aws_s3_bucket_versioning.evidence]

  rule {
    id     = "ReplicateToHyderabad"
    status = "Enabled"

    destination {
      bucket        = var.replica_bucket_arn
      storage_class = "STANDARD"
    }
  }
}
