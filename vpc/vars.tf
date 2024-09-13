variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet" {
  type = object({
    cidr = string
    az   = string
  })
}
variable "private_subnet" {
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnet_count" {
  type = number
}
