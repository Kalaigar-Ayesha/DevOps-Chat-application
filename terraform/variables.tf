variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
  default     = "chatapp"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (web tier)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "Private subnet CIDRs (app tier)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_subnet_cidrs" {
  description = "Private subnet CIDRs (db tier)"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to SSH to instances (set to your public IP/32; can be null to disable SSH ingress)"
  type        = string
  default     = null
}

variable "ec2_key_name" {
  description = "Optional EC2 key pair name (required if you want SSH access)"
  type        = string
  default     = null
}

variable "instance_type_web" {
  description = "Instance type for web tier"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_app" {
  description = "Instance type for app tier"
  type        = string
  default     = "t3.micro"
}

variable "frontend_image" {
  description = "Container image for frontend (nginx + built assets). Example: <account>.dkr.ecr.<region>.amazonaws.com/chat-frontend:latest"
  type        = string
}

variable "backend_image" {
  description = "Container image for backend (node server). Example: <account>.dkr.ecr.<region>.amazonaws.com/chat-backend:latest"
  type        = string
}

variable "jwt_secret" {
  description = "Backend JWT secret (required by backend/src/index.js unless NODE_ENV=test)"
  type        = string
  sensitive   = true
}

variable "cloudinary_url" {
  description = "Cloudinary connection URL (used by backend if you enable uploads); can be empty"
  type        = string
  sensitive   = true
  default     = ""
}

variable "docdb_master_username" {
  description = "DocumentDB master username"
  type        = string
  default     = "chatapp"
}

variable "docdb_master_password" {
  description = "DocumentDB master password"
  type        = string
  sensitive   = true
}

variable "docdb_instance_class" {
  description = "DocumentDB instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "eks_node_instance_type" {
  description = "Worker node instance type for AWS EKS"
  type        = string
  default     = "t3.medium"
}

variable "eks_desired_node_count" {
  description = "Desired number of worker nodes in EKS Managed Node Group"
  type        = number
  default     = 2
}

variable "eks_min_node_count" {
  description = "Minimum number of worker nodes in EKS Managed Node Group"
  type        = number
  default     = 1
}

variable "eks_max_node_count" {
  description = "Maximum number of worker nodes in EKS Managed Node Group"
  type        = number
  default     = 4
}


