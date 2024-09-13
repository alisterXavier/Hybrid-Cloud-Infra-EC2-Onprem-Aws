variable "ACCESS_KEY" {
  type = string
}

variable "SECRET_ACCESS_KEY" {
  type = string
}

locals {
  account_id      = data.aws_caller_identity.current.account_id
  connection_type = "ipsec.1"
  domain          = "hybrid.com"

  on_prem_vpc_cidr = "192.168.0.0/20"
  on_prem_region   = "us-east-1"
  on_prem_public_subnet = {
    az : "us-east-1a",
    cidr : "192.168.0.0/21"
  }
  on_prem_private_subnet = [{
    az : "us-east-1a",
    cidr : "192.168.8.0/21"
  }]

  aws_region   = "us-east-1"
  aws_vpc_cidr = "10.0.0.0/19"
  aws_public_subnet = {
    az : "us-east-1a",
    cidr : "10.0.0.0/28"
  }
  aws_private_subnets = [{
    az : "us-east-1a",
    cidr : "10.0.16.0/21"
    }, {
    az : "us-east-1b",
    cidr : "10.0.24.0/21"
  }]

}

data "aws_caller_identity" "current" {}
