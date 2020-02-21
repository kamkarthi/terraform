resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow ALB inbound traffic"
  vpc_id      = var.MAINVPC_ID

  dynamic ingress {
    iterator = port
    for_each = var.ALB_INGRESS_PORT

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}