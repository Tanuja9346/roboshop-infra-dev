data "aws_ssm_parameter" "vpc_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpc_id"
}
data "aws_ssm_parameter" "vpn_sg_id" {      #querying vpn from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpn_sg_id"
}
data "aws_ssm_parameter" "database_subnet_ids" {      #querying database from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/database_subnet_ids"
}
# data "aws_ssm_parameter" "database_subnet_ids" {      #querying database from ssm parameter hub`
#   name = "/${var.project_name}/${var.env}/database_subnet_ids"
# }
data "aws_ssm_parameter" "mongodb_sg_id" {      #querying database from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/mongodb_sg"
}
# data "aws_ami" "devops_ami" {
#   most_recent      = true
#   name_regex       = "Centos-8-DevOps-Practice"
#   owners           = ["973714476881"]

#   filter {
#     name   = "name"
#     values = ["Centos-8-DevOps-Practice"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }