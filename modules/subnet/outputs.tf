output "public_subnet_id_az1" {
  value = aws_subnet.public_subnet_az1.id
}

output "private_subnet_id_az1" {
  value = aws_subnet.private_subnet_az1.id
}

output "nat_gateway_id_az1" {
  value = aws_nat_gateway.nat_gtw_az1.id
}
