resource "aws_ecr_repository" "services" {
  for_each             = toset(var.repository_names)
  name                 = "${var.project_name}/${var.environment}/${each.value}"
  image_tag_mutability = "IMMUTABLE" # Prevents overwriting tags (cosign signature requirement)

  image_scanning_configuration {
    scan_on_push = true # Vulnerability scanning (Trivy / Inspector)
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.value}"
    Environment = var.environment
    Service     = each.value
    ManagedBy   = "Terraform"
  }
}

# Lifecycle policy to retain latest 30 images and clean untagged images
resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 30 tagged production images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Cross-Region Replication to Hyderabad (ap-south-2)
data "aws_caller_identity" "current" {}

resource "aws_ecr_replication_configuration" "replication" {
  count = var.enable_replication ? 1 : 0

  replication_configuration {
    rule {
      destination {
        region      = var.dr_region
        registry_id = data.aws_caller_identity.current.account_id
      }
    }
  }
}
