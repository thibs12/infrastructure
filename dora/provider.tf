provider "aws" {
  region  = "eu-west-1"
  #profile = "default"
}

# Grafana provider
provider "grafana" {
  url  = "http://${aws_instance.grafana.public_ip}:3000"
  auth = "admin:Doratests75016"
}
