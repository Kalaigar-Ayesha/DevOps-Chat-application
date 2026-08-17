output "bucket_arn" {
  value       = aws_s3_bucket.tf_state.arn
  description = "ARN of the Terraform State S3 Bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.tf_state.id
  description = "ID / Name of the Terraform State S3 Bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.tf_locks.name
  description = "Name of the DynamoDB State Lock Table"
}

output "kms_key_arn" {
  value       = aws_kms_key.tf_kms.arn
  description = "ARN of the KMS key encrypting state files"
}
