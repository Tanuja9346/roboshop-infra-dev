#creation of app alb i.e private alb
resource "aws_lb" "app-alb" {
  name               = "${var.project_name}-${var.common_tags.component}"
  internal           = true  #private is ntg but internal
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  #for high availability u need to give 2 subnets ibn alb that is condition and above split give list of 2 subnets.
#   enable_deletion_protection = true and subnet is for where u want to provision.

 
  tags = var.common_tags
}
#add listner 80 in internal  bcz its internal and complete traffic is within our network
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  #this will add one listner on port no 80 and one default rule i.e default
 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "this is Fixed response alb"
      status_code  = "200"
    }
  }
}

#it will create the record for alb internal because fixed dns name
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "joindevops.xyz"

  records = [
    {
      name    = "*.app"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ] 
}
