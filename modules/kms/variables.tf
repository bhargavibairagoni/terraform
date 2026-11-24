variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "description" {
  type        = string
  default     = "Multi-region KMS key for Britannia Compliance platform data encryption"
  description = "KMS key description"
}
