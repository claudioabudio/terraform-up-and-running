provider "aws" {
  region = "us-east-2"
  alias  = "primary"
}

provider "aws" {
  region = "us-west-1"
  alias  = "replica"
}

module "mysql_primary" {
  providers = {
    aws = aws.primary
  }
  source = "../../modules/data-stores/mysql"

  db_name     = "example_database_prod"
  db_username = var.db_username
  db_password = var.db_password

  # Must be enabled to support replication
  backup_retention_period = 1
}

module "mysql_replica" {
  providers = {
    aws = aws.replica
  }

  source = "../../modules/data-stores/mysql"

  replicate_source_db = module.mysql_primary.arn
}
