# Define AWS provide 
provider "aws" {
    region = "us-east-1"
}

# Define an EC2 instance with Ubuntu AMI
resource "aws_instance" "mi_servidor" {
    ami = "ami-08d4ac5b634553e16"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

    // Wrote a "here document" which is used during initialization
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello world, I'm server 1." > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    
    tags = {
        Name = "Server-1"
    }   
}

# Define a security group with access to port:8080
resource "aws_security_group" "mi_grupo_de_seguridad" {
    name = "server-1-sg"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Access to port:8080"
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
    }
}