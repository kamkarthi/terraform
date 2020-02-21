module "backend" {
  source          = "./modules/backend"
}

module "vpc" {
  source          = "./modules/vpc"
  CIDR_BLOCK      = var.CIDR_BLOCK
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
}

module "alb" {
  source             = "./modules/alb"
  ALB_INGRESS_PORT   = var.ALB_INGRESS_PORT
  MAINVPC_ID         = module.vpc.mainvpc_id
  PUBLIC_SUBNET_IDS  = module.vpc.private_subnet_ids
  PRIVATE_SUBNET_IDS = module.vpc.private_subnet_ids
  CERT_CN            = "FOO.COM"
  CERT_ORGANIZATION  = "ACME, INC"
}