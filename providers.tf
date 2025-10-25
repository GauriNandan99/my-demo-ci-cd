terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

backend "s3" {
  dynamodb_table = "demoterraformstate"
  bucket = "demotfbackend"
  key = "demo/terraform.tfstate"
  region = "ap-south-1"
}


provider "aws" {
  region = var.region
}
