output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "CloudFront distribution domain name"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "CloudFront distribution ID"
}

output "frontend_bucket_name" {
  value       = aws_s3_bucket.frontend.id
  description = "S3 bucket for frontend code deployment"
}

output "ingestion_documents_bucket_name" {
  value       = aws_s3_bucket.documents.id
  description = "S3 bucket for attendance/salary/statutory raw files"
}

