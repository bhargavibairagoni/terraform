output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "alb_dns_name" {
  value       = module.compute_ec2.alb_dns_name
  description = "ALB Backend DNS Name"
}

output "cloudfront_url" {
  value       = "https://${module.frontend_cdn.cloudfront_domain_name}"
  description = "CloudFront URL for accessing the Frontend application"
}

output "rds_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS PostgreSQL connection endpoint"
}

output "db_credentials_secret_arn" {
  value       = module.rds.db_secret_arn
  description = "AWS Secrets Manager ARN holding the DB password"
}

output "frontend_s3_bucket" {
  value       = module.frontend_cdn.frontend_bucket_name
  description = "S3 bucket for frontend build files"
}

output "documents_s3_bucket" {
  value       = module.frontend_cdn.ingestion_documents_bucket_name
  description = "S3 bucket for contractor raw attendance and validation files"
}

