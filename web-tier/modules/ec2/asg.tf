resource "aws_autoscaling_group" "web-tier-asg" {
  name                      = "web-tier-asg"
  max_size                  = 5
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = var.PUBLIC_SUBNET_IDS

  tag {
    key                 = "Name"
    value               = "web-tier-asg-instance"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "project"
    value               = "web-tier"
    propagate_at_launch = false
  }

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web-tier-asg.id
  alb_target_group_arn   = var.ALB_TARGET_GROUP_ARN
}

resource "aws_cloudwatch_metric_alarm" "monitor_asg_cpu" {
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.asg_policy_step.arn]
  alarm_name          = "asg-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-tier-asg.name
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "60"
  statistic          = "Average"
  threshold          = "70"
}

resource "aws_autoscaling_policy" "asg_policy_step" {
  adjustment_type        = "PercentChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web-tier-asg.name
  name                   = "scale_up"
  policy_type            = "StepScaling"

  # Step 1 (Normal)
  step_adjustment {
    scaling_adjustment          = 15
    metric_interval_lower_bound = 0  # Zero over CW threshold
    metric_interval_upper_bound = 15 # 15 over CW threshold (70 + 15 = 85)
  }

  # Step 2 (Spike)
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 15 # 15 over CW threshold (70 + 15 = 85)
  }
}