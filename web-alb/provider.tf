terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
  }
  backend "s3" {
    bucket = "roboshop-remote-sta"
    key = "vpc1"
    region = "us-east-1"
    dynamodb_table = "robhoshop-locking"
  }
}

provider "aws" {
  # Configuration options
  #u can give access key and seceret key here, but security problem.
    region = "us-east-1"

}