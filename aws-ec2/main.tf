resource "aws_instance" "instance" {
  count                  = length(var.private_subnet_ids)
  subnet_id              = var.private_subnet_ids[count.index]
  ami                    = "ami-0e86e20dae9224db8"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  user_data              = templatefile("Hybrid Cloud/user_data.sh", {})
  tags = {
    Name = "${var.vpc_name} server"
  }
}

resource "aws_security_group" "instance" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = [var.on_prem_vpc_cidr]
    security_groups = [var.alb_sg_id]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.vpc_name} instance"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = var.instance_role_name
}
