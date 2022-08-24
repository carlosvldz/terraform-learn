# Define AWS provider
provider "aws" {
  region = local.region
}

# Local variables
locals {
  region = "us-east-1"
  ami = var.ubuntu_ami[local.region]
}

# Data source that obtains id from AZ
data "aws_subnet" "public_subnet" {
    for_each = var.servers
    availability_zone = "${local.region}${each.value.az}"
}

# Define EC2 instances with Ubuntu AMI
resource "aws_instance" "server" {
  for_each = var.servers
  ami = local.ami
  instance_type = var.instance_type
  subnet_id = data.aws_subnet.public_subnet[each.key].id // each.key is ser-1 or ser-2
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Wrote a "here document" which is used during initialization
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world, I'm ${each.value.name}." > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = each.value.name
  }
}

# Define a security group with access to port 8080
resource "aws_security_group" "mi_grupo_de_seguridad" {
    name = "primer-servidor-sg"

    ingress {
        security_groups = [aws_security_group.alb.id]
        description = "Acceso al puerto 8080 desde el exterior"
        from_port = var.server_port
        to_port = var.server_port
        protocol = "TCP"
    }
}

# Public load balancer
resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraformers-alb"
    security_groups = [ aws_security_group.alb.id ]
    subnets = [for subnet in data.aws_subnet.public_subnet : subnet.id]
}

# Load balancer security group
resource "aws_security_group" "alb" {
    name = "alb-sg"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Access to port 80 from outside"
      from_port = var.lb_port
      protocol = "TCP"
      to_port = var.lb_port
    }

    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Access to port 8080 from our servers"
      from_port = var.server_port
      protocol = "TCP"
      to_port = var.server_port
    }
}

# Data source to obtain the default VPC id
data "aws_vpc" "default" {
    default = true
}

# Load balancer Target Group
resource "aws_lb_target_group" "this" {
  name = "terraform-alb-target-group"
  port = var.lb_port
  vpc_id = data.aws_vpc.default.id
  protocol = "HTTP"

  health_check {
    enabled = true
    matcher = "200"
    path ="/"
    port = var.server_port
    protocol = "HTTP"
  }
}

# Attachment for servers
resource "aws_lb_target_group_attachment" "server" {
  for_each = var.servers
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.server[each.key].id
  port = var.server_port
}

# Load balancer listener
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.lb_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type = "forward"
  }
}