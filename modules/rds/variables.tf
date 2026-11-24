variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name"
}

variable "engine_version" {
  type        = string
  default     = "16.4" # Or "18" per Britannia v3 specification as available in AWS RDS
  description = "PostgreSQL engine version"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t4g.medium"
  description = "RDS instance class (e.g. db.t4g.small, db.t4g.medium, db.r6g.large)"
}

variable "allocated_storage" {
  type        = number
  default     = 50
  description = "Allocated storage in GB"
}

variable "max_allocated_storage" {
  type        = number
  default     = 200
  description = "Max auto-scaling storage in GB"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ deployment"
}

variable "db_name" {
  type        = string
  default     = "britanniacompliance"
  description = "Database name"
}

variable "db_username" {
  type        = string
  default     = "dbadmin"
  description = "Master username"
}

variable "db_subnet_group_name" {
  type        = string
  description = "DB Subnet group name"
}

variable "rds_security_group_id" {
  type        = string
  description = "Security group ID for RDS"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "KMS Key ARN for storage encryption"
}

variable "backup_retention_period" {
  type        = number
  default     = 30 # Enables Point-In-Time Recovery (PITR)
  description = "Backup retention period in days (enables Point-In-Time Recovery)"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Enable deletion protection"
}
