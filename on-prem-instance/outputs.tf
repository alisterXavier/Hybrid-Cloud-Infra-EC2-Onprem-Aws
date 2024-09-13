output "cgw_id" {
  value = aws_instance.cgw_instance.id
}

output "cgw_public_ip" {
  value = aws_instance.cgw_instance.public_ip
}
output "cgw_private_ip" {
  value = aws_instance.cgw_instance.private_ip
}