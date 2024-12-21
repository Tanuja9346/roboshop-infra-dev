resource "aws_ssm_parameter" "mongodb_sg_id" {
  name  = "/${var.project_name}/${var.env}/mongodb_sg"
  type  = "String"
  value = module.mongodb_sg.security_group_id # module should have output declaration
}
