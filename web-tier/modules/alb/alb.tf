resource "aws_lb" "front-end" {
  #for_each           = var.PUBLIC_SUBNET_IDS
  name               = "front-end-web-tier"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.PUBLIC_SUBNET_IDS

  enable_deletion_protection = var.ALB_DELETE_PROTECTION

  tags = {
    Name        = "front-end-web-tier"
    project     = "web-tier"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "front-end-lb-tg" {
  name     = "front-end-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.MAINVPC_ID
}

resource "aws_lb_listener" "front-end-listener-http" {
  load_balancer_arn = aws_lb.front-end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "tls_private_key" "front-end-priv-key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "fron-end-selfsigned-cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.front-end-priv-key.private_key_pem

  subject {
    common_name  = var.CERT_CN
    organization = var.CERT_ORGANIZATION
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "front-endcert" {
  private_key      = tls_private_key.front-end-priv-key.private_key_pem
  certificate_body = tls_self_signed_cert.fron-end-selfsigned-cert.cert_pem

  tags = {
    Name    = "self-signed-cert"
    project = "web-tier"
  }
}


resource "aws_lb_listener" "front-end-listener-https" {
  load_balancer_arn = aws_lb.front-end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.front-endcert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-end-lb-tg.arn
  }
}

resource "aws_lb_listener_certificate" "front-end-listener-cert" {
  listener_arn    = aws_lb_listener.front-end-listener-https.arn
  certificate_arn = aws_acm_certificate.front-endcert.arn
}