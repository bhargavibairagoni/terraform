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
  description = "KMS Key ARN for server-side encryption"
}

variable "retention_days" {
  type        = number
  default     = 1825 # 5 years statutory retention (EPFO/ESIC/Contract Labour Act)
  description = "Number of days for statutory evidence retention under Governance Mode"
}

variable "enable_replication" {
  type        = bool
  default     = false
  description = "Enable Cross-Region Replication to Hyderabad (ap-south-2)"
}

variable "replica_bucket_arn" {
  type        = string
  default     = ""
  description = "ARN of the replica S3 bucket in Hyderabad (ap-south-2) if replication is enabled"
}
