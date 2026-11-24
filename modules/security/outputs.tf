output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "ALB Security Group ID"
}

output "ec2_app_security_group_id" {
  value       = aws_security_group.ec2_app.id
  description = "EC2 Application Security Group ID"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds.id
  description = "RDS Security Group ID"
}

output "ec2_instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_profile.name
  description = "IAM instance profile name for EC2 SSM access"
}

