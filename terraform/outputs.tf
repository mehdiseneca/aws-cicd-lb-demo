output "alb_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = aws_lb.web.dns_name
}

output "instance_ids" {
  description = "IDs of the EC2 web server instances"
  value       = aws_instance.web[*].id
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 web server instances"
  value       = aws_instance.web[*].public_ip
}
