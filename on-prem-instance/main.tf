resource "aws_instance" "instance" {
  ami                    = "ami-0e86e20dae9224db8"
  instance_type          = "t2.medium"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
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
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "cgw_instance" {
  ami                         = "ami-0182f373e66f89c85"
  instance_type               = "t2.medium"
  source_dest_check           = true
  vpc_security_group_ids      = [aws_security_group.cgw.id]
  subnet_id                   = var.public_subnet_id
  iam_instance_profile        = aws_iam_instance_profile.cgw_profile.name
  associate_public_ip_address = true
  tags = {
    Name = "${var.vpc_name}-CGW"
  }
}
resource "aws_security_group" "cgw" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.on_prem_vpc_cidr, var.aws_vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name} cgw"
  }
}
resource "aws_iam_instance_profile" "cgw_profile" {
  role = var.cgw_role_name
}
