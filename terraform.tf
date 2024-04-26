terraform {
  required_version = ">= 1.7.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tf-state-todolist"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-lock"
    encrypt        = true
  }
}
