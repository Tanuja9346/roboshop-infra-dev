variable "project_name" {
 default = "roboshop"  
}
variable "env"{
    default = "dev"
}

variable "common_tags"{
    default = {
        project = "Roboshop"
        component = "vpn"
        Environment = "DEV"
        Terraform = "true"
    }
}
# variable "subnet_id"{
#     default = {}
# }