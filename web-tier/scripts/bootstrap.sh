#!/bin/bash

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
cd ..

if [ -f terraform.tf ]; then
  echo -e "\n WARN: Found existing terraform backend configuration file, take care managing related tfstate \n"
  echo -e "\n INFO: Inorder to initialize terraform tfstate backend for new infra setup, you must delete this file `pwd`/terraform.tf and bootstrap it again \n"
  exit 0
fi

terraform init
terraform plan -target=module.backend -out /tmp/terraform-fc234.plan
terraform apply /tmp/terraform-fc234.plan
rm -f /tmp/terraform-fc234.plan

cat <<-EOF> terraform.tf
terraform {
 backend "s3" {
 encrypt = true
 bucket = "$(terraform output tfstate_s3_bucket)"
 dynamodb_table = "$(terraform output tfstate_lock_dynamodb)"
 region = "eu-west-1"
 key = "terraform/tfstate"
 }
}
EOF

terraform init -force-copy
rm -f terraform.tfstate terraform.tfstate.backup
