module "backend" {
  source = "./modules/backend"
}

module "vpc" {
  source          = "./modules/vpc"
  CIDR_BLOCK      = var.CIDR_BLOCK
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
}

module "alb" {
  source                = "./modules/alb"
  ALB_INGRESS_PORT      = var.ALB_INGRESS_PORT
  MAINVPC_ID            = module.vpc.mainvpc_id
  PUBLIC_SUBNET_IDS     = module.vpc.public_subnet_ids
  PRIVATE_SUBNET_IDS    = module.vpc.private_subnet_ids
  ALB_DELETE_PROTECTION = false
  CERT_CN               = "FOO.COM"
  CERT_ORGANIZATION     = "ACME, INC"
}

module "ec2" {
  source               = "./modules/ec2"
  MAINVPC_ID           = module.vpc.mainvpc_id
  EC2_INGRESS_PORT     = ["22"]
  ALB_SG_ID            = module.alb.alb_sg_id
  ALB_TARGET_GROUP_ARN = module.alb.target_group_arn
  PUBLIC_SUBNET_IDS    = module.vpc.public_subnet_ids
  PRIVATE_SUBNET_IDS   = module.vpc.private_subnet_ids
}