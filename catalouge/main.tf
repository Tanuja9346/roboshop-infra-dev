#ntg but creting group
resource "aws_lb_target_group" "catalogue" {
  name        = "${var.project_name}-${var.common_tags.component}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  health_check {  #it is ntg but it has responding specific skills or nnot
    enabled = true
    healthy_threshold = 2 #consider as health if 2 health checks sucess here health is instance
    interval = 15 # every 15secs check the health checkup
    matcher = "200-299"  #considerd as a sucess.
    path = "/health" #developers enabled this u will get response if the componnet is healthy
    port = 8080
    protocol = "HTTP"
    timeout = 5  #within 5sec u should get response otherwise it is unhealthy threshold
    unhealthy_threshold = 3 #3 times consecutive apply failes component is failed

  }
}

resource "aws_launch_template" "catalogue" {
  name = "${var.project_name}-${var.common_tags.component}"


  image_id = data.aws_ami.devops_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "catalogue"
    }
  }

  user_data = filebase64("${path.module}/catalogue.sh")
}

##creating autoscalling to catalogue component
resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project_name}-${var.common_tags.component}"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300 #install user data in instances iy takes time ryt so it si 300sec
  health_check_type         = "ELB" #check instance health by alb, lb responsbility 
  desired_capacity          = 2
  target_group_arns = [aws_lb_target_group.catalogue.arn] #u should add target group to autoscalling
  launch_template {
    id       = aws_launch_template.catalogue.id
    version = "$latest"
  }
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value )
                       #for HA we are giving 2subnet

  tag {
    key                 = "Name"
    value               = "catalogue"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}
#creating autoscalingpolicy 
resource "aws_autoscaling_policy" "example" {
  # .which group autoscaling is here ...
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
#condition for add a rule for call one componnet to other
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.app_lb_listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }


  condition {
    host_header {
      values = ["catalogue.app.joindevops.xyz"]
    }
  }
}
##example user componnet call catalogue through catalouge.app.joindevops.xyz this request go to lb so lb have entry of that rule and send to catalouge target group.