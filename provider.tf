terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"


  backend "s3" {
    bucket = "asmt-cmba-terraform-state"
    key    = "task1/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
     