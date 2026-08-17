variable "name_prefix" {
  type        = string
  description = "Prefix for AWS resource names"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "chatapp-eks-cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for node groups"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for EKS worker nodes"
  default     = "t3.medium"
}

variable "desired_node_count" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 2
}

variable "min_node_count" {
  type        = number
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 4
}

variable "docdb_security_group_id" {
  type        = string
  description = "Security group ID for DocumentDB cluster"
}
