variable "name_prefix" {
  type        = string
  description = "Prefix for AWS resource names"
}

variable "domain_name" {
  type        = string
  description = "Primary domain name for the ACM certificate"
  default     = "chatapp.yourdomain.com"
}

variable "alternative_names" {
  type        = list(string)
  description = "Subject alternative names for the certificate"
  default     = []
}
