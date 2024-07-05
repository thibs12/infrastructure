data "terraform_remote_state" "app" {
  backend = "s3"

  config = {
    bucket = "tf-state-todolist"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

