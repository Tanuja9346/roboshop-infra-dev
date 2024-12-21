resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.component}"
  internal           = false  #private is ntg but internal
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  tags = var.common_tags
}
#create certificate
resource "aws_acm_certificate" "joindevops" {
  domain_name       = "joindevops.xyz"
  validation_method = "DNS"
  tags = var.common_tags
}
data "aws_route53_zone" "joindevops" {
  name         = "joindevops.xyz"      #checking zone data source
  private_zone = false
}

resource "aws_route53_record" "records" {    #create the sub domain record i.e dns going to give in alias
  for_each = {
    for dvo in aws_acm_certificate.joindevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.joindevops.zone_id
}

resource "aws_acm_certificate_validation" "joindevops" {   # do validation for certificate
  certificate_arn         = aws_acm_certificate.joindevops.arn
  validation_record_fqdns = [for record in aws_route53_record.records : record.fqdn]
}
#adding listner
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.joindevops.arn
  
      default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "this is the fixed response from web alb https "
      status_code  = "200"
    }
  }
}
#it will create the record for alb enternal because fixed dns name
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "joindevops.xyz"

  records = [
    {
      name    = ""
      type    = "A"
      alias   = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ] 
}
    


# #add listner 443 in externel i.e outside u need certificate acm(amazon certificate manager)
# # resource "aws_lb_listener" "https" {
# #   load_balancer_arn = aws_lb.web_alb.arn
# #   port              = "443"
# #   protocol          = "HTTPS"

# #   #this will add one listner on port no 80 and one default rule i.e default
# #  default_action {
# #     type = "fixed-response"

# #     fixed_response {
# #       content_type = "text/plain"
# #       message_body = "this is Fixed response alb"
# #       status_code  = "200"
# #     }
# #   }
# # }