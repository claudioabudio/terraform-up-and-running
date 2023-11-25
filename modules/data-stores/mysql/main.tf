resource "aws_db_instance" "example_db" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = var.replicate_source_db == null ? "mysql" : null
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = var.replicate_source_db == null ? var.db_name : null

  # How should we set the username and password?
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null

  backup_retention_period = var.backup_retention_period

  # If specified, this DB will be a replica
  replicate_source_db = var.replicate_source_db
}