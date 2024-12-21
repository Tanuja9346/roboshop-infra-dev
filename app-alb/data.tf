data "aws_ssm_parameter" "vpc_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpc_id1"
}
data "aws_ssm_parameter" "app_alb_sg_id" {      #querying vpn from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/app_alb_sg_id"
}
data "aws_ssm_parameter" "private_subnet_ids" {      #querying vpn from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/private_subnet_ids"
}