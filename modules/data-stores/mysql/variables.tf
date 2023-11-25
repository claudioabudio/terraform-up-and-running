variable "db_name" {
  description = "Name for the DB."
  type        = string
  default     = null
}

variable "db_username" {
  type        = string
  description = "master user for mysql rds db"
  sensitive   = true
  default     = null
}

variable "db_password" {
  type        = string
  description = "master password for mysql rds db"
  sensitive   = true
  default     = null
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be > 0 to enable replication."
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "If specified, replicate the RDS database at the given ARN."
  type        = string
  default     = null
}