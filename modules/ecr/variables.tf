variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN for ECR encryption"
}

variable "repository_names" {
  type        = list(string)
  default     = ["bff", "product-apis", "workflow-engine", "rules-engine", "document-intelligence"]
  description = "List of microservice repository names"
}

variable "enable_replication" {
  type        = bool
  default     = false
  description = "Enable replication to Hyderabad (ap-south-2)"
}

variable "dr_region" {
  type        = string
  default     = "ap-south-2"
  description = "Disaster Recovery region"
}
