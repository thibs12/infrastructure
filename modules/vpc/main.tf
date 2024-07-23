resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-VPC"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-IGW"
    }
  )
}
