provider "aws" {
  region = "us-east-1"
}

module "web-server" {
  source = "../../../modules/services/webserver-cluster"
  db_remote_state_bucket = "claudioabud-terraform-state"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  cluster_name = "webservers-stage"
}