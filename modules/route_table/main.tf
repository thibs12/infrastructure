## PUBLIC ROUTE TABLE
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Public-${var.route_table_name}"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id

  depends_on = [aws_route_table.public_route_table]
}

resource "aws_route_table_association" "public_rt_association_az1" {
  subnet_id      = var.public_subnet_ids[0]
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table]
}

resource "aws_route_table_association" "public_rt_association_az2" {
  subnet_id      = var.public_subnet_ids[1]
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table]
}

## PRIVATE ROUTE TABLE
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Private-${var.route_table_name}-AZ1"
  }
}

resource "aws_route" "private_route_az1" {
  route_table_id         = aws_route_table.private_route_table_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[0]

  depends_on = [aws_route_table.private_route_table_az1]
}

resource "aws_route_table_association" "private_rt_association_az1" {
  subnet_id      = var.private_subnet_ids[0]
  route_table_id = aws_route_table.private_route_table_az1.id

  depends_on = [aws_route_table.private_route_table_az1]
}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Private-${var.route_table_name}-AZ2"
  }
}

resource "aws_route" "private_route_az2" {
  route_table_id         = aws_route_table.private_route_table_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[1]

  depends_on = [aws_route_table.private_route_table_az2]
}

resource "aws_route_table_association" "private_rt_association_az2" {
  subnet_id      = var.private_subnet_ids[1]
  route_table_id = aws_route_table.private_route_table_az2.id

  depends_on = [aws_route_table.private_route_table_az2]
}
