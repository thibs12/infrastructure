resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-${var.subnet_name}-AZ1"
  }
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-${var.subnet_name}-AZ1"
  }
}

resource "aws_eip" "eip_nat_gtw_az1" {
  domain = "vpc"

  tags = {
    Name = "EIP-${var.nat_gtw_name}-AZ1"
  }
}

resource "aws_nat_gateway" "nat_gtw_az1" {
  allocation_id = aws_eip.eip_nat_gtw_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.nat_gtw_name}-AZ1"
  }

}
