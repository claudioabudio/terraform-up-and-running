provider "aws" {
  region = "us-east-1"
  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner     = "team-foo"
      ManagedBy = "Terraform"
    }
  }
}

module "web-server" {
  source                 = "../../../modules/services/webserver-cluster"
  db_remote_state_bucket = "claudioabud-terraform-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
  cluster_name           = "webservers-prod"
  enable_autoscaling     = true
  custom_tags = {
    Environment = "prod"
    Owner       = "team-foo"
    ManagedBy   = "Terraform"
  }
}

