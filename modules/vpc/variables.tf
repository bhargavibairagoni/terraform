variable "environment" {
  type        = string
  description = "Environment name (dev, uat, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
  default     = "britannia-compliance"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to use"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (ALB, NAT GW)"
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private app subnets (EC2/EKS)"
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private database subnets (RDS)"
}

variable "enable_ha_nat_gateway" {
  type        = bool
  default     = false
  description = "If true, creates 1 NAT Gateway per AZ (for prod). If false, creates 1 single NAT Gateway (for dev/uat cost saving)."
}

