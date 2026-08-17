# Terraform Remote State Configuration
# Stores terraform.tfstate securely in AWS S3 with DynamoDB State Locking and SSE-KMS Encryption.

terraform {
  backend "s3" {
    bucket         = "chatapp-tfstate-bucket-us-east-1"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "chatapp-tfstate-locks"
    encrypt        = true
  }
}
