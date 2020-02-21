resource "aws_dynamodb_table" "tfstate" {
  name           = "web-tier-terraform-lock-tfstate"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "tfstate"
    project = "web-tier"
  }

}