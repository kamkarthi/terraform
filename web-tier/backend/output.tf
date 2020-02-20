output "tfstate_s3_bucket" {
 value = aws_s3_bucket.tfstate.bucket
}

output "tfstate_lock_dynamodb" {
  value = aws_dynamodb_table.tfstate.name
}
