resource "aws_ssm_document" "document" {
  name            = "Configure_CGW"
  document_type   = "Command"
  document_format = "YAML"
  content = templatefile("/ssm/libre.yaml", {
    vpnConnectionId = var.vpnConnectionId
    vpcRegion       = var.vpcRegion
    onPremVpcCidr   = var.onPremVpcCidr
    awsVpcCidr      = var.awsVpcCidr
    domain          = var.domain
    r53ResolverIp1  = var.resolver_ip1
    r53ResolverIp2  = var.resolver_ip2
    vpcRouter       = var.vpc_host
  })
}

resource "aws_ssm_association" "ssm_association" {
  name = aws_ssm_document.document.name
  targets {
    key    = "InstanceIds"
    values = [var.cgw_id]
  }

  parameters = {
    vpnConnectionId = var.vpnConnectionId
    vpcRegion       = var.vpcRegion
    onPremVpcCidr   = var.onPremVpcCidr
    awsVpcCidr      = var.awsVpcCidr
    domain          = var.domain
    r53ResolverIp1  = var.resolver_ip1
    r53ResolverIp2  = var.resolver_ip2
    vpcRouter       = var.vpc_host
  }
}
