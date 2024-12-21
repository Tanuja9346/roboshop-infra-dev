resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.env}/vpn_sg_id"
  type  = "String"
  value = module.vpn_sg.security_group_id #this module should have output  module declaration.
}# this vpc is existing usermodule name.
