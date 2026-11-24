terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Remote backend configuration (uncomment after running backend-bootstrap)
  # backend "s3" {
  #   bucket         = "britannia-contractor-compliance-tf-state-ap-south-1"
  #   key            = "environments/dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "britannia-contractor-compliance-tf-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Factory     = "Factory-01-Pilot"
    }
  }
}

