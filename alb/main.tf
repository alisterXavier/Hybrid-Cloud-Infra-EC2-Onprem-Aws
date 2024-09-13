resource "aws_lb" "load_balancer" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.private_subnet_ids
  internal           = true
  access_logs {
    bucket  = var.s3_id
    prefix  = "alb"
    enabled = true
  }
  tags = {
    Name = "load_balancer"
  }
}

resource "aws_security_group" "lb" {
  name = "load_balancer"
  vpc_id = var.vpc_id
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [var.on_prem_vpc_cidr]
  }
  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = [var.on_prem_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "load_balancer"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = var.vpc_name
  vpc_id      = var.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(var.instances)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instances[count.index]
}
