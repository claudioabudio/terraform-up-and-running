

provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "example_instance_sg" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_launch_configuration" "example_lc" {
  image_id        = "ami-0261755bbcb8c4a84"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.example_instance_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_asg" {
  launch_configuration = aws_launch_configuration.example_lc.name

  min_size = 2
  max_size = 10

  vpc_zone_identifier = data.aws_subnets.default_subnets.ids
  target_group_arns   = [aws_lb_target_group.example_tg.arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}