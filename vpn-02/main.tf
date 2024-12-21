#create ec2 instance and security group for vpn
module "vpn_sg"{
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    sg_name = "roboshop_vpn"
    sg_description = "allowing all ports from my home network"
    # sg_ingress_rules = var.sg_ingress_rules create ingress rules seprately
    vpc_id = data.aws_vpc.default.id
    common_tags = var.common_tags 
}

resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]  #giving entrey from my home network
  security_group_id = module.vpn_sg.security_group_id
}
module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami =  "ami-0453ec754f44f9a4a"   #here fetchinhg ami using datasource
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
#   this is optional, if we dont give this will be provisioned inside the default subnet of default vpc
#   subnet_id =  [data.aws_subnet.selected[0]] 
tags = merge(
{
    Name = "Roboshop_vpn"
},var.common_tags

)
}
# # resource "aws_subnet" "main" {
#   vpc_id     = data.aws_vpc.default.id
#   cidr_block = "10.0.3.0/24"
# }
# 