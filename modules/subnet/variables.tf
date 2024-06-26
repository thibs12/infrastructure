variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = []
}

variable "subnet_name" {
  description = "The name of the public subnet"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "The availability zone for the subnet"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = []
}

variable "nat_gtw_name" {
  description = "The name of the NAT gateway"
  type        = string
  default     = ""
}
