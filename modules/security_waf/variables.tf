variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "alb_arn" {
  type        = string
  default     = ""
  description = "ALB ARN to associate regional WAF with"
}
