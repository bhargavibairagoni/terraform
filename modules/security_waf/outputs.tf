output "alb_web_acl_arn" {
  value       = aws_wafv2_web_acl.alb.arn
  description = "ARN of the Regional WAF Web ACL for ALB"
}

output "alb_web_acl_id" {
  value       = aws_wafv2_web_acl.alb.id
  description = "ID of the Regional WAF Web ACL for ALB"
}
