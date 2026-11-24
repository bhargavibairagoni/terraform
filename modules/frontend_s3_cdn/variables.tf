variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name"
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name to route /api/* traffic directly through CloudFront"
}

variable "route53_zone_id" {
  type        = string
  default     = ""
  description = "Route 53 hosted zone ID (optional)"
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Custom domain name (e.g. compliance.dev.britannia.com) (optional)"
}

variable "web_acl_id" {
  type        = string
  default     = ""
  description = "AWS WAF Web ACL ID for CloudFront (optional)"
}

