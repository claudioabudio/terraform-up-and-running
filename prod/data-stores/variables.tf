variable "db_username" {
  type        = string
  description = "master user for mysql rds db"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "master password for mysql rds db"
  sensitive   = true
}