variable "server_port" {
    description = "Port for instance EC2"
    type = number
    default = 8080

    validation {
        condition = var.server_port > 0 && var.server_port <= 65536
        error_message = "The port value must be defined between 1 and 65536"
    }
}

variable "lb_port" {
    description = "Port for Load Balancer"
    type = number
    default = 80
}

variable "instance_type" {
    description = "Type for EC2 instance"
    type = string
    default = "t2.micro"
}

variable "ubuntu_ami" {
  description = "AMI by region"
  type = map(string)

  default = {
    us-east-1 = "ami-08d4ac5b634553e16" # Ubuntu AMI in east us
    us-west-1 = "ami-01154c8b2e9a14885" # Ubuntu AMI in west us
  }
}