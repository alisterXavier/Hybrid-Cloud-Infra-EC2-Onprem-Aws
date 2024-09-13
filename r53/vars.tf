variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "on_prem_vpc_cidr" {
  type = string
}

variable "load_balancer_dns_name" {
  type = string
}

variable "load_balancer_zone_id" {
  type = string
}
