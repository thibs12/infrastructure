variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = ""
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = ""
}

variable "nat_gtw_name" {
  description = "The name of the NAT gateway"
  type        = string
  default     = ""
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
  default     = ""
}
