output "secret_arn" {
  value       = aws_secretsmanager_secret.backend_secrets.arn
  description = "ARN of the created AWS Secrets Manager secret"
}

output "secret_name" {
  value       = aws_secretsmanager_secret.backend_secrets.name
  description = "Name of the created AWS Secrets Manager secret"
}

output "eso_policy_arn" {
  value       = aws_iam_policy.eso_secrets_policy.arn
  description = "ARN of the IAM policy for External Secrets Operator"
}
