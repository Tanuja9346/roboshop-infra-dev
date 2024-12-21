data "aws_vpc" "default" {              #get default vpc.
  default = true
} 
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"   #http request for our ip address to get
}
data "aws_ssm_parameter" "vpc_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpc_id"
}
data "aws_ssm_parameter" "vpn_sg_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpn_sg_id"
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
#}
# variable "subnet_id" {}

# data "aws_subnet" "selected" {
#   id = var.subnet_id
#}

