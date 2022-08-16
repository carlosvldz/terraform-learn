variable "server_port" {
    description = "Port for instance EC2"
    type = number
    default = 8080
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