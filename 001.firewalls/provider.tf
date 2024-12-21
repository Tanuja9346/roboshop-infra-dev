terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
  }
  backend "s3" {
    bucket = "roboshop-remotestate"
    key = "firewalls"
    region = "us-east-1"
    dynamodb_table = "roboshoplocking"
  }
}

provider "aws" {
  # Configuration options
  #u can give access key and seceret key here, but security problem.
    region = "us-east-1"

}