output "public_dns_servers" {
  description = "Server public DNS"  
  value = [for server in aws_instance.server : "http://${server.public_dns}:${var.server_port}"
  ]
}

output "dns_load_balancer" {
  description = "Load balancer public DNS"  
  value = "http://${aws_lb.alb.dns_name}:${var.lb_port}"
}