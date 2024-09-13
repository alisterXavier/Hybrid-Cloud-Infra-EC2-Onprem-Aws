variable "private_subnet_ids" {
  type = list(string)
}
variable "on_prem_vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "instances" {
  type = list(string)
}
variable "s3_id" {
  type = string
}
