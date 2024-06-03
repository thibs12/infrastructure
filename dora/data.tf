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
