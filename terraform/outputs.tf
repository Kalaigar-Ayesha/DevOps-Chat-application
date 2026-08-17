output "web_alb_dns_name" {
  value       = module.web.alb_dns_name
  description = "Public web ALB DNS name. Open this in a browser."
}

output "app_alb_dns_name" {
  value       = module.app.alb_dns_name
  description = "Internal app ALB DNS name (reachable only inside the VPC)."
}

output "docdb_endpoint" {
  value       = module.docdb.endpoint
  description = "DocumentDB cluster endpoint."
}

output "secrets_manager_arn" {
  value       = module.secrets_manager.secret_arn
  description = "AWS Secrets Manager secret ARN for External Secrets Operator."
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "AWS EKS Managed Cluster Name."
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "AWS EKS Control Plane Endpoint."
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "OIDC Provider ARN for IAM Roles for Service Accounts (IRSA)."
}

output "kubectl_config_command" {
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
  description = "Command to configure local kubectl to connect to the AWS EKS cluster."
}

output "acm_certificate_arn" {
  value       = module.acm.certificate_arn
  description = "AWS ACM Certificate ARN for HTTPS ALB listener."
}

output "waf_web_acl_arn" {
  value       = module.waf.web_acl_arn
  description = "AWS WAF v2 Web ACL ARN protecting Application Load Balancers."
}





