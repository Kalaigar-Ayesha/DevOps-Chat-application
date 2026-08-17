resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.name_prefix}-acm-cert"
    Environment = var.name_prefix
    ManagedBy   = "Terraform"
  }
}
