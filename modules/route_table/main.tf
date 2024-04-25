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

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table]
}

## PRIVATE ROUTE TABLE
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Private-${var.route_table_name}"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id

  depends_on = [aws_route_table.private_route_table]
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private_route_table.id

  depends_on = [aws_route_table.private_route_table]
}
