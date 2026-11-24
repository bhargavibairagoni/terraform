output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "Public DNS name of the Application Load Balancer"
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "Route 53 hosted zone ID for the ALB"
}

output "alb_arn" {
  value       = aws_lb.main.arn
  description = "ARN of the ALB"
}

output "asg_name" {
  value       = aws_autoscaling_group.app.name
  description = "Auto Scaling Group Name"
}

