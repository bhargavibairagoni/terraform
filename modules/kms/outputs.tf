output "key_arn" {
  value       = aws_kms_key.primary.arn
  description = "ARN of the primary KMS key"
}

output "key_id" {
  value       = aws_kms_key.primary.key_id
  description = "ID of the primary KMS key"
}

output "alias_arn" {
  value       = aws_kms_alias.primary.arn
  description = "ARN of the KMS alias"
}
