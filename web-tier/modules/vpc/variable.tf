variable "CIDR_BLOCK" {}

variable "PUBLIC_SUBNETS" {
  type = list(string)
}

variable "PRIVATE_SUBNETS" {
  type = list(string)
}