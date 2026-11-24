variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "app_port" {
  type        = number
  default     = 8080
  description = "Application listening port on EC2 backend"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Allowed CIDR blocks for ALB (can be restricted to Britannia office/VPN IPs)"
}

