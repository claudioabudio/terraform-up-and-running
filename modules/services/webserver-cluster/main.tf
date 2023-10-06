locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}


data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-1"
  }
}

resource "aws_security_group" "example_instance_sg" {
  name = "${var.cluster_name}-inst-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
}




resource "aws_launch_configuration" "example_lc" {
  image_id        = "ami-0261755bbcb8c4a84"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.example_instance_sg.id]

  user_data = templatefile("${path.module}/user-data.sh", {
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    server_port = var.server_port
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_asg" {
  launch_configuration = aws_launch_configuration.example_lc.name

  min_size = var.min_size
  max_size = var.max_size

  vpc_zone_identifier = data.aws_subnets.default_subnets.ids
  target_group_arns   = [aws_lb_target_group.example_tg.arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags
    iterator = custom_tag
    content {
        key = custom_tag.key
        value = custom_tag.value
        propagate_at_launch = true
    }
  }
}