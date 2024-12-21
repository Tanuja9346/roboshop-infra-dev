variable "project_name" {
 default = "roboshop"  
}
variable "env"{
    default = "dev"
}

variable "common_tags"{
    default = {
        project = "Roboshop"
        # component = "mongodb"
        Environment = "DEV"
        Terraform = "true"
    }
}
