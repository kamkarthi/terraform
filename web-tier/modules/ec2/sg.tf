resource "aws_security_group" "web-tier-sg" {
  name        = "web-tier-sg"
  description = "Allow inbound traffic to instances"
  vpc_id      = var.MAINVPC_ID

  dynamic ingress {
    iterator = port
    for_each = var.EC2_INGRESS_PORT

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.ALB_SG_ID]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}