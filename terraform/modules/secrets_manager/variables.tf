variable "name_prefix" {
  type        = string
  description = "Prefix for AWS resource names"
  default     = "production"
}

variable "mongodb_uri" {
  type        = string
  description = "MongoDB connection string"
  sensitive   = true
  default     = "mongodb://mongo:27017/chatapp"
}

variable "jwt_secret" {
  type        = string
  description = "JWT secret key"
  sensitive   = true
}

variable "client_url" {
  type        = string
  description = "Frontend client URL"
  default     = "http://localhost:5173"
}

variable "cloudinary_url" {
  type        = string
  description = "Cloudinary connection URL"
  sensitive   = true
  default     = ""
}
