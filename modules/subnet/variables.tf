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

variable "tags" {
  description = "A map of tags to add to all subnets"
  type        = map(string)
  default     = {}
}
