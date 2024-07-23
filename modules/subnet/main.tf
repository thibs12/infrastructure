# AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      "Name" = "DORA-Public-Subnet-AZ1"
    }
  )
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    {
      "Name" = "DORA-Private-Subnet-AZ1"
    }
  )
}

resource "aws_eip" "eip_nat_gtw_az1" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-EIP-NAT-GTW-AZ1"
    }
  )
}

resource "aws_nat_gateway" "nat_gtw_az1" {
  allocation_id = aws_eip.eip_nat_gtw_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-NAT-GTW-AZ1"
    }
  )
}

# AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      "Name" = "DORA-Public-Subnet-AZ2"
    }
  )
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    {
      "Name" = "DORA-Private-Subnet-AZ2"
    }
  )
}

resource "aws_eip" "eip_nat_gtw_az2" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-EIP-NAT-GTW-AZ2"
    }
  )
}

resource "aws_nat_gateway" "nat_gtw_az2" {
  allocation_id = aws_eip.eip_nat_gtw_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = merge(
    var.tags,
    {
      "Name" = "DORA-NAT-GTW-AZ2"
    }
  )
}
