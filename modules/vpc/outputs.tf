output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

output "private_app_subnet_ids" {
  value       = aws_subnet.private_app[*].id
  description = "List of private app subnet IDs"
}

output "private_db_subnet_ids" {
  value       = aws_subnet.private_db[*].id
  description = "List of private DB subnet IDs"
}

output "db_subnet_group_name" {
  value       = aws_db_subnet_group.rds.name
  description = "Database subnet group name for RDS"
}

output "nat_gateway_ips" {
  value       = aws_eip.nat[*].public_ip
  description = "EIPs of the NAT Gateways (useful for whitelisting with external Matra/HRMS APIs)"
}

