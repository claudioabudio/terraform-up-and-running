

provider "aws" {
    region = "us-east-1"
}

resource aws_instance "example" {
    ami = "ami-0261755bbcb8c4a84"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.example_instance_sg.id]
    tags = {
        Name = "terraform-example"
    }


    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

    user_data_replace_on_change = true
}


resource "aws_security_group" "example_instance_sg" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}