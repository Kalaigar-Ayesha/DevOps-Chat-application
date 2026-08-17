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


