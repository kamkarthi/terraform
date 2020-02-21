#!/bin/bash

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
cd ..

ssh-keygen -b 2048 -t rsa -f web-tier-sshkey -q -N ""

if [ -f terraform.tf ]; then
  echo -e "\n INFO: Found existing terraform backend configuration under `pwd`/terraform.tf, take care managing related provisioned resources and its tfstate"
  echo -e ' INFO: To perform normal deployments just continue executing "terraform apply"'
  echo -e "\n WARN: Inorder to destruct and initialize completely, first cleanup any managed resources including its backend setup(s3 bucket and dynamodb table) and then delete this file `pwd`/terraform.tf and bootstrap it again \n"
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

terraform apply -auto-approve
