output "alb_dns_name" {
  value       = module.web-server.alb_dns_name
  description = "DNS name of the application load balancer"
}