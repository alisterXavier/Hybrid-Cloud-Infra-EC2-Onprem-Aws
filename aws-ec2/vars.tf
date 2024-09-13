variable "vpc_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "on_prem_vpc_cidr" {
  type = string
}
variable "alb_sg_id" {
  type = string
}
variable "instance_role_name" {
  type = string
}
