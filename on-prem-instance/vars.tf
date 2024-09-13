variable "vpc_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_id" {
  type = string
}
variable "public_subnet_id" {
  type = string
}
variable "on_prem_vpc_cidr" {
  type = string
}
variable "aws_vpc_cidr" {
  type = string
}
variable "instance_role_name" {
  type = string
}
variable "cgw_role_name" {
  type = string
}
