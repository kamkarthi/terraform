output "tfstate_s3_bucket" {
  value = module.backend.tfstate_s3_bucket
}

output "tfstate_lock_dynamodb" {
  value = module.backend.tfstate_lock_dynamodb
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
