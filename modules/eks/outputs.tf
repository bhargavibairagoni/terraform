output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "EKS Cluster Name"
}

output "cluster_arn" {
  value       = aws_eks_cluster.main.arn
  description = "EKS Cluster ARN"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "EKS Cluster Endpoint"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
  description = "EKS Cluster Certificate Authority Data"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.cluster.arn
  description = "EKS OIDC Provider ARN for IAM Roles for Service Accounts (IRSA)"
}

output "oidc_provider" {
  value       = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
  description = "EKS OIDC Provider URL without scheme"
}
