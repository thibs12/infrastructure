output "vpc_id" {
  value       = aws_vpc.custom_vpc.id
  description = "AWS VPC ID"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "AWS Internet Gateway ID"

}
