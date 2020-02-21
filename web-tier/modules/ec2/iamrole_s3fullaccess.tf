resource "aws_iam_role" "ec2-iam-role" {
  name = "ec2-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name    = "ec2-iam-role"
    project = "web-tier"
  }
}

resource "aws_iam_policy" "s3-iam-admin-policy" {
  name        = "s3-iam-admin-policy"
  path        = "/"
  description = "s3-iam-admin-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "ec2-policy-attach" {
  name       = "ec2-policy-attach"
  roles      = [aws_iam_role.ec2-iam-role.name]
  policy_arn = aws_iam_policy.s3-iam-admin-policy.arn
}

resource "aws_iam_instance_profile" "ec2-iam-profile" {
  name = "ec2-iam-profile"
  role = aws_iam_role.ec2-iam-role.name
}