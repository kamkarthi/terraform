resource "aws_s3_bucket" "tfstate" {

  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "tfstate-bucket"
    project = "web-tier"
  }
}