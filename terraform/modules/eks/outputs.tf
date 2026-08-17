output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS Cluster Name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS Control Plane Endpoint"
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "EKS Cluster ARN"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Base64 encoded certificate data required to communicate with the cluster"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.oidc.arn
  description = "ARN of the OIDC Provider for IRSA"
}

output "oidc_provider_url" {
  value       = aws_iam_openid_connect_provider.oidc.url
  description = "URL of the OIDC Provider for IRSA"
}
