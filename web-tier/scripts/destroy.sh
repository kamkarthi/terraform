#!/bin/bash

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
cd ..

TFSTATE_S3_BUCKET=$(terraform output tfstate_s3_bucket)

terraform destroy -auto-approve
echo -e "\nINFO: Ignore any error about S3 bucket ${TFSTATE_S3_BUCKET}. Deleting this bucket is handle by other script - delete_bucket.py \n"
rm -fr .terraform
rm -f terraform.tf*
rm -f web-tier-sshkey*


python3 ./scripts/delete_bucket.py "${TFSTATE_S3_BUCKET}"

echo -e "\nDestroy action completed...\n"
