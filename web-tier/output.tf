output "tfstate_s3_bucket" {
  value = module.backend.tfstate_s3_bucket
}

output "tfstate_lock_dynamodb" {
  value = module.backend.tfstate_lock_dynamodb
}


output "mainvpc_id" {
  value = module.vpc.mainvpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
  #value = tolist([for s in module.vpc.public_subnet_ids : s.id])
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
  #value = tolist([for s in module.vpc.private_subnet_ids : s.id])
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}