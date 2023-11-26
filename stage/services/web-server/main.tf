provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "web-server" {
  source                 = "../../../modules/services/webserver-cluster"
  db_remote_state_bucket = "claudioabud-terraform-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  cluster_name           = "webservers-stage"
  server_text            = "Back to the old server !"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
}