module "redis_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id    #here fetchinhg ami using datasource
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  #it should be provision in roboshop db subent and how to get first element in ssm paramter string list in string i need to split it and get first element.
  subnet_id = local.db_subnet_id
  #creating one more instance.
  user_data = file("redis.sh")
tags = merge(
{
    Name = "redis"
},var.common_tags

)
}

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  zone_name = var.zone_name
  records = [
    {
        name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
         module.redis_instance.private_ip
      ]
    }
  ]
} 