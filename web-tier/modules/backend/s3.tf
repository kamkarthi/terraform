resource "aws_s3_bucket" "tfstate" {

  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name    = "tfstate-bucket"
    project = "web-tier"
  }
}