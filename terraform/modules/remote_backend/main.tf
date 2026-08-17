# KMS Key for SSE-KMS State Encryption
resource "aws_kms_key" "tf_kms" {
  description             = "KMS Key for Terraform State Bucket Encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name_prefix}-tfstate-kms"
    Environment = var.name_prefix
    ManagedBy   = "Terraform"
  }
}

resource "aws_kms_alias" "tf_kms_alias" {
  name          = "alias/${var.name_prefix}-tfstate-kms"
  target_key_id = aws_kms_key.tf_kms.key_id
}

# S3 Bucket for Terraform Remote State
resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = {
    Name        = var.bucket_name
    Environment = var.name_prefix
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_crypto" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_privacy" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB Table for Distributed State Locking
resource "aws_dynamodb_table" "tf_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = var.table_name
    Environment = var.name_prefix
    ManagedBy   = "Terraform"
  }
}
