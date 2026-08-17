variable "name_prefix" {
  type        = string
  description = "Prefix for AWS resource names"
  default     = "chatapp"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for Terraform remote state"
  default     = "chatapp-tfstate-bucket-us-east-1"
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table for Terraform state locking"
  default     = "chatapp-tfstate-locks"
}
