variable "project_name" {
 default = "roboshop"  
}
variable "env"{
    default = "dev"
}

variable "common_tags"{
    default = {
        project = "Roboshop"
        component = "web"
        Environment = "DEV"
        Terraform = "true"
    }
}
variable "health_check" {
  default = {
    enabled = true
    healthy_threshold = 2 #consider as health if 2 health checks sucess here health is instance
    interval = 15 # every 15secs check the health checkup
    matcher = "200-299"  #considerd as a sucess.
    path = "/" #developers enabled this u will get response if the componnet is healthy for web
    port = 80
    protocol = "HTTP"
    timeout = 5  #within 5sec u should get response otherwise it is unhealthy threshold
    unhealthy_threshold = 3 #3 times consecutive apply 

  }
}
variable "target_group_port" {
 default = 80
  
}
variable "target_group_protocol" {
  default = "HTTP"
}
# variable "vpc_id" {

# }
  
variable "launch_template_tags" {
  default = [
    {
        resource_type = "instance"
        tags = {
            Name = "web"
        }
    },
    {
        resource_type = "volume"
        tags = {
            Name = "web"
        }
    }
  ]
}
variable "autoscalling_tags" {
  default = [
    {
        key =      "Name"
        value =     "web"
        propagate_at_launch =  true
    },
       { 
        key = "project"
        value = "roboshop"
        propagate_at_launch = true
     }
  ]
  
}