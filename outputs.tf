output "alb_dns_name" {
  value       = aws_lb.example_alb.dns_name
  description = "The dns host name of the application load balancer"
}