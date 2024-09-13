output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "route_table_id" {
  value = aws_route_table.private_route_table.id
}