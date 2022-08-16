# Define AWS provider
provider "aws" {
  region = "us-east-1"
}

# Data source that obtains id from AZ us-east-1b
data "aws_subnet" "az_b" {
    availability_zone = "us-east-1b"
}

# Data source that obtains id from AZ us-east-1d
data "aws_subnet" "az_d" {
    availability_zone = "us-east-1d"
}

# Define the first EC2 instance with Ubuntu AMI
resource "aws_instance" "server_1" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.az_b.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Wrote a "here document" which is used during initialization
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world, I'm server 1." > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "server-1"
  }
}

# Define the second EC2 instance with Ubuntu AMI
resource "aws_instance" "server_2" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.az_d.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Wrote a "here document" which is used during initialization
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world, I'm server 2." > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "server-2"
  }
}

# Define a security group with access to port 8080
resource "aws_security_group" "mi_grupo_de_seguridad" {
    name = "primer-servidor-sg"

    ingress {
        security_groups = [aws_security_group.alb.id]
        description = "Acceso al puerto 8080 desde el exterior"
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
    }
}

# Public load balancer with two instances
resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraformers-alb"
    security_groups = [ aws_security_group.alb.id ]
    subnets = [ data.aws_subnet.az_b.id, data.aws_subnet.az_d.id ]
}

# Load balancer security group
resource "aws_security_group" "alb" {
    name = "alb-sg"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Access to port 80 from outside"
      from_port = 80
      protocol = "TCP"
      to_port = 80
    }

    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Access to port 8080 from our servers"
      from_port = 8080
      protocol = "TCP"
      to_port = 8080
    }
}

# Data source to obtain the default VPC id
data "aws_vpc" "default" {
    default = true
}

# Load balancer Target Group
resource "aws_lb_target_group" "this" {
  name = "terraform-alb-target-group"
  port = 80
  vpc_id = data.aws_vpc.default.id
  protocol = "HTTP"

  health_check {
    enabled = true
    matcher = "200"
    path ="/"
    port = "8080"
    protocol = "HTTP"
  }
}

# Attachment for server 1
resource "aws_lb_target_group_attachment" "server_1" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.server_1.id
  port = 8080
}

# Attachment for server 2
resource "aws_lb_target_group_attachment" "server_2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.server_2.id
  port = 8080
}

# Load balancer listener
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type = "forward"
  }
}