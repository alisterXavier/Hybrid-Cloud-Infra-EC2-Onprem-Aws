resource "aws_vpn_connection" "vpn" {
  type                     = var.type
  customer_gateway_id      = aws_customer_gateway.cgw.id
  vpn_gateway_id           = aws_vpn_gateway.vpn_gateway.id
  local_ipv4_network_cidr  = var.on_prem_vpc_cidr
  remote_ipv4_network_cidr = var.aws_vpc_cidr
  static_routes_only       = true
  tags = {
    Name = "VPN"
  }
}
resource "aws_vpn_connection_route" "vpn_connection_route" {
  vpn_connection_id      = aws_vpn_connection.vpn.id
  destination_cidr_block = var.on_prem_vpc_cidr
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = var.vpc_id
  tags = {
    Name = "VPN Gateway"
  }
}

resource "aws_customer_gateway" "cgw" {
  type       = var.type
  ip_address = var.cgw_ip
}

resource "aws_vpn_gateway_route_propagation" "main" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = var.route_table_id
}


# resource "aws_vpn_gateway_attachment" "vpn_attachment" {
#   vpc_id         = var.vpc_id
#   vpn_gateway_id = aws_vpn_gateway.vgw.id
# }
