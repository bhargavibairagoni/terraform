variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for the ALB"
}

variable "private_app_subnet_ids" {
  type        = list(string)
  description = "Private app subnets for EC2 Auto Scaling instances"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group for the ALB"
}

variable "ec2_security_group_id" {
  type        = string
  description = "Security group for EC2 instances"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "EC2 Instance type (e.g. t3.small for dev, t3.medium for prod)"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum instances in ASG"
}

variable "max_size" {
  type        = number
  default     = 2
  description = "Maximum instances in ASG"
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired number of instances in ASG"
}

variable "app_port" {
  type        = number
  default     = 8080
  description = "Application port"
}

variable "health_check_path" {
  type        = string
  default     = "/health"
  description = "Health check path for ALB"
}

