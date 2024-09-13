module "aws_vpc" {
  source               = "./vpc"
  vpc_cidr             = local.aws_vpc_cidr
  public_subnet        = local.aws_public_subnet
  private_subnet       = local.aws_private_subnets
  vpc_name             = "AWS"
  private_subnet_count = 2
}

module "aws_instance" {
  source             = "./aws-ec2"
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_vpc.private_subnet_ids
  vpc_name           = "AWS"
  on_prem_vpc_cidr   = local.on_prem_vpc_cidr
  instance_role_name = module.iam.ec2_instance_role
  alb_sg_id          = module.load_balancer.alb_sg_id
}
module "iam" {
  source = "./iam"
}
module "s3" {
  source = "./s3"
  acc_id = local.account_id
}
module "load_balancer" {
  source             = "./alb"
  vpc_id             = module.aws_vpc.vpc_id
  vpc_name           = "AWS"
  s3_id              = module.s3.s3_id
  private_subnet_ids = module.aws_vpc.private_subnet_ids
  on_prem_vpc_cidr   = local.on_prem_vpc_cidr
  instances          = module.aws_instance.instance_ids
}
module "r53" {
  source                 = "./r53"
  load_balancer_dns_name = module.load_balancer.load_balancer_dns_name
  load_balancer_zone_id  = module.load_balancer.load_balancer_zone_id
  vpc_id                 = module.aws_vpc.vpc_id
  on_prem_vpc_cidr       = local.on_prem_vpc_cidr
  domain                 = local.domain
  private_subnet_ids     = module.aws_vpc.private_subnet_ids
}
module "on_prem_vpc" {
  source               = "./vpc"
  vpc_cidr             = local.on_prem_vpc_cidr
  public_subnet        = local.on_prem_public_subnet
  vpc_name             = "On-prem"
  private_subnet_count = 1
  private_subnet       = local.on_prem_private_subnet
}
module "on_prem_instance" {
  source             = "./on-prem-instance"
  vpc_name           = "On-prem"
  aws_vpc_cidr       = local.aws_vpc_cidr
  on_prem_vpc_cidr   = local.on_prem_vpc_cidr
  vpc_id             = module.on_prem_vpc.vpc_id
  instance_role_name = module.iam.ec2_instance_role
  cgw_role_name      = module.iam.cgw_instance_role
  private_subnet_id  = module.on_prem_vpc.private_subnet_ids[0]
  public_subnet_id   = module.on_prem_vpc.public_subnet_id
}
module "ssm" {
  source          = "./ssm"
  cgw_id          = module.on_prem_instance.cgw_id
  vpcRegion       = "us-east-1"
  vpnConnectionId = module.vpn.vpn_connection_id
  awsVpcCidr      = local.aws_vpc_cidr
  onPremVpcCidr   = local.on_prem_vpc_cidr
  vpc_host        = cidrhost(local.on_prem_vpc_cidr, 2)
  resolver_ip1    = module.r53.resolver_ips[0]
  resolver_ip2    = module.r53.resolver_ips[1]
  domain          = local.domain
}
module "vpn" {
  source           = "./vpn"
  on_prem_vpc_cidr = local.on_prem_vpc_cidr
  aws_vpc_cidr     = local.aws_vpc_cidr
  type             = local.connection_type
  cgw_ip           = module.on_prem_instance.cgw_public_ip
  vpc_id           = module.aws_vpc.vpc_id
  route_table_id   = module.aws_vpc.route_table_id
}

resource "aws_vpc_dhcp_options" "aws_vpc_dhcp_options" {
  domain_name         = "hybrid.com"
  domain_name_servers = [module.on_prem_instance.cgw_private_ip, "AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "aws_vpc_dhcp_options_association" {
  vpc_id          = module.on_prem_vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.aws_vpc_dhcp_options.id
}
