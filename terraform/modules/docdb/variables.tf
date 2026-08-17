variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DocumentDB"
}

variable "master_username" {
  type        = string
  description = "Master username"
}

variable "master_password" {
  type        = string
  description = "Master password"
  sensitive   = true
}

variable "instance_class" {
  type        = string
  description = "DocumentDB instance class"
}

variable "instance_count" {
  type        = number
  description = "Number of DocumentDB cluster instances across AZs"
  default     = 3
}


