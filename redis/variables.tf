variable "project_name" {
 default = "roboshop"  
}
variable "env"{
    default = "dev"
}

variable "common_tags"{
    default = {
        project = "Roboshop"
        component = "redis"
        Environment = "DEV"
        Terraform = "true"
    }
}

variable "zone_name" {
  default = "joindevops.xyz"
}