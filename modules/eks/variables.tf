variable "project_name" {
  type        = string
  default     = "britannia-compliance"
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "cluster_version" {
  type        = string
  default     = "1.37"
  description = "EKS Kubernetes Version (v3 spec: EKS 1.37)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS is deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs for EKS worker nodes"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN for EKS secret encryption"
}

variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "Instance types for EKS managed node group"
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum number of worker nodes"
}

variable "max_size" {
  type        = number
  default     = 6
  description = "Maximum number of worker nodes"
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Desired number of worker nodes"
}
