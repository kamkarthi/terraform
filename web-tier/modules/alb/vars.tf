variable "ALB_INGRESS_PORT" {
  type = list(string)
}

variable "MAINVPC_ID" {}

variable "PUBLIC_SUBNET_IDS" {
  type = list(string)
}

variable "PRIVATE_SUBNET_IDS" {
  type = list(string)
}

variable "ALB_DELETE_PROTECTION" {
  type    = bool
  default = true
}

variable "CERT_CN" {}
variable "CERT_ORGANIZATION" {}