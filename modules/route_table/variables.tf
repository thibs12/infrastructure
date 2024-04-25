variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
  default     = ""
}

variable "internet_gateway_id" {
  description = "The ID of the internet gateway"
  type        = string
  default     = ""
}

variable "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  type        = string
  default     = ""
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
  default     = ""
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
  default     = ""
}
