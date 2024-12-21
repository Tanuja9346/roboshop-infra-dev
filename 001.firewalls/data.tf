data "aws_vpc" "default" {              #get default vpc.
  default = true
} 
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"   #our ip address to get
}

data "aws_ssm_parameter" "vpc_id" {      #querying vpcid from ssm parameter hub`
  name = "/${var.project_name}/${var.env}/vpc_id"
}
