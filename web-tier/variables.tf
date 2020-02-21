variable "CIDR_BLOCK" {
  default = "10.0.0.0/16"
}

variable "PUBLIC_SUBNETS" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "PRIVATE_SUBNETS" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "ALB_INGRESS_PORT" {
  type    = list(string)
  default = ["80", "443"]
}
