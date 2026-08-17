output "certificate_arn" {
  value       = aws_acm_certificate.this.arn
  description = "ARN of the AWS ACM Certificate"
}

output "certificate_domain" {
  value       = aws_acm_certificate.this.domain_name
  description = "Domain name of the ACM Certificate"
}
