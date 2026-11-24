output "bucket_name" {
  value       = aws_s3_bucket.evidence.id
  description = "Name of the statutory evidence S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.evidence.arn
  description = "ARN of the statutory evidence S3 bucket"
}
