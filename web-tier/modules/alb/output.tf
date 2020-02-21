output "alb_dns_name" {
  value = aws_lb.front-end.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_sg_arn" {
  value = aws_security_group.alb_sg.arn
}


output "target_group_arn" {
  value = aws_lb_target_group.front-end-lb-tg.arn
}