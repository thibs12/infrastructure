variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable "internet_gateway_id" {
  description = "The ID of the internet gateway"
  type        = string
  default     = ""
}

variable "nat_gateway_ids" {
  description = "The ID of the NAT gateways"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "The ID of the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "The ID of the private subnet"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all route tables"
  type        = map(string)
  default     = {}
}
