output "load_balancer_dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.load_balancer.zone_id
}

output "alb_sg_id" {
  value = aws_security_group.lb.id
}