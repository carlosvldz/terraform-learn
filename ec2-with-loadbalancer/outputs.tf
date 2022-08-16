output "public_dns_server_1" {
  description = "Server public DNS"  
  value = "http://${aws_instance.server_1.public_dns}:8080"
}

output "dns_publica" {
  description = "Server public DNS"  
  value = "http://${aws_instance.server_2.public_dns}:8080"
}

output "dns_load_balancer" {
  description = "Load balancer public DNS"  
  value = "http://${aws_lb.alb.dns_name}"
}