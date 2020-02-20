terraform {
 backend "s3" {
 encrypt = true
 bucket = "terraform-20200220081917271500000001"
 dynamodb_table = "web-tier-terraform-lock-tfstate"
 region = "eu-west-1"
 key = "terraform/tfstate"
 }
}
