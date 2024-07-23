resource "aws_subnet" "private_db_subnet_az1" {
  vpc_id                  = data.terraform_remote_state.app.outputs.vpc_id
  cidr_block              = var.private_subnet_cidr[0]
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false
  tags = merge(var.tags, {
    Name = "DORA-private-db-subnet-az1-2"
  })
}

resource "aws_subnet" "private_db_subnet_az2" {
  vpc_id                  = data.terraform_remote_state.app.outputs.vpc_id
  cidr_block              = var.private_subnet_cidr[1]
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false
  tags = merge(var.tags, {
    Name = "DORA-private-db-subnet-az2-2"
  })
}

## db subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "dora-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_subnet_az1.id, aws_subnet.private_db_subnet_az2.id]
  tags = merge(var.tags, {
    Name = "DORA-db-subnet-group"
  })
}

## PRIVATE ROUTE TABLE
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = data.terraform_remote_state.app.outputs.vpc_id

  tags = merge(var.tags, {
    Name = "DORA-private-route-table-az1-2"
  })
}

resource "aws_route" "private_route_az1" {
  route_table_id         = aws_route_table.private_route_table_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.terraform_remote_state.app.outputs.nat_gateway_ids[0]

  depends_on = [aws_route_table.private_route_table_az1]
}

resource "aws_route_table_association" "private_rt_association_az1" {
  subnet_id      = aws_subnet.private_db_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_az1.id

  depends_on = [aws_route_table.private_route_table_az1]
}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = data.terraform_remote_state.app.outputs.vpc_id

  tags = merge(var.tags, {
    Name = "DORA-private-route-table-az2-2"
  })
}

resource "aws_route" "private_route_az2" {
  route_table_id         = aws_route_table.private_route_table_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.terraform_remote_state.app.outputs.nat_gateway_ids[1]

  depends_on = [aws_route_table.private_route_table_az2]
}

resource "aws_route_table_association" "private_rt_association_az2" {
  subnet_id      = aws_subnet.private_db_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_az2.id

  depends_on = [aws_route_table.private_route_table_az2]
}