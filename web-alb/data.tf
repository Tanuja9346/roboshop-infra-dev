data "aws_ssm_parameter" "web_alb_sg_id" {      #querying  from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/web_alb_sg_id"
}
data "aws_ssm_parameter" "public_subnet_ids" {      #querying  from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/public_subnet_ids"
}
data "aws_ssm_parameter" "vpc_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpc_id1"
}