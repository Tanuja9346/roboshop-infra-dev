module "mongodb_sg"{
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    sg_name = "mongodb"
    sg_description = "allowing traffic"
    # sg_ingress_rules = var.sg_ingress_rules create ingress rules seprately
    vpc_id = data.aws_ssm_parameter.vpc_id.value    #our roboshop vpc.
    common_tags = var.common_tags 
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value  #allowing traffice (connection) from vpn .
#   cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]  #giving entrey from my home network
  security_group_id = module.mongodb_sg.security_group_id
}  #if the traffice is increase create another or more  instancevpn and give same sg then our mongodb accept the request.


 module "mongodb_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami =  "ami-0453ec754f44f9a4a"  #here fetchinhg ami using datasource
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  #it should be provision in roboshop db subent and how to get first element in ssm paramter string list in string i need to split it and get first element.
  subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value),0)

  #creating one more instance.
  user_data = file("mongodb.sh")
tags = merge(
{
    Name = "mongodb"
},var.common_tags

)
}

# module "zones" {
#   source  = "terraform-aws-modules/route53/aws//modules/zones"
#   zone_name = var.zone_name
#   records = [
#     {
#         name    = "mongodb"
#       type    = "A"
#       ttl     = 1
#       records = [
#          module.mongodb_instance.private_ip
#       ]
#     }
#   ]
# } 