resource "aws_route53_zone" "private_zone" {
  name = var.domain
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "test.${var.domain}"
  type    = "A"

  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name               = "inbound_resolver_endpoint"
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.resolver_endpoint.id]
  dynamic "ip_address" {
    for_each = var.private_subnet_ids
    content {
      subnet_id = ip_address.value
    }

  }
}

resource "aws_security_group" "resolver_endpoint" {
  vpc_id = var.vpc_id
  name   = "resolver endpoint"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.on_prem_vpc_cidr]
  }
  # ingress {
  #   from_port   = 53
  #   to_port     = 53
  #   protocol    = "udp"
  #   cidr_blocks = [var.on_prem_vpc_cidr]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "resolver endpoint"
  }
}
