resource "aws_secretsmanager_secret" "backend_secrets" {
  name        = "${var.name_prefix}/chatapp/backend"
  description = "Production secrets for DevOps Chat Application backend"

  tags = {
    Environment = var.name_prefix
    Application = "DevOps-Chat-App"
    ManagedBy   = "Terraform"
  }
}

resource "aws_secretsmanager_secret_version" "backend_secrets_val" {
  secret_id = aws_secretsmanager_secret.backend_secrets.id
  secret_string = jsonencode({
    MONGODB_URI    = var.mongodb_uri
    JWT_SECRET     = var.jwt_secret
    CLIENT_URL     = var.client_url
    CLOUDINARY_URL = var.cloudinary_url
  })
}

resource "aws_iam_policy" "eso_secrets_policy" {
  name        = "${var.name_prefix}-eso-secrets-policy"
  description = "IAM Policy allowing External Secrets Operator to access AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.backend_secrets.arn
        ]
      }
    ]
  })
}
