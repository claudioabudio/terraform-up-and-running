provider "aws" {
  region = "us-east-1"
}

module "web-server" {
  source                 = "../../../modules/services/webserver-cluster"
  db_remote_state_bucket = "claudioabud-terraform-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
  cluster_name           = "webservers-prod"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.web-server.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.web-server.asg_name
}