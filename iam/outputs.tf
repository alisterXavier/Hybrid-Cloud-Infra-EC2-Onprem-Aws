output "ec2_instance_role" {
  value = aws_iam_role.Ec2Role.name
}

output "cgw_instance_role" {
  value = aws_iam_role.cgwRole.name
}