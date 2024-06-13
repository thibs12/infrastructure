variable "sg_name" {
  type        = string
  description = "Name of the security group"
  default     = ""
}

variable "db_username" {
  type        = string
  description = "Username for the RDS instance"
  default     = ""
}

variable "db_password" {
  type        = string
  description = "Password for the RDS instance"
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for the private subnets"
  default     = []
}

variable "route_table_name" {
  type        = string
  description = "Name of the route table"
  default     = ""
}

variable "db_endpoint" {
  type        = string
  description = "Endpoint for the RDS instance"
  default     = ""
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = ""
}

variable "clusterArn" {
  type        = string
  description = "ARN of the ECS cluster"
  default     = ""
}

variable "log_group_name" {
  type        = string
  description = "Name of the log group of the application"
  default     = ""
}

variable "log_group_arn" {
  type        = string
  description = "ARN of the log group of the application"
  default     = ""
}

variable "service_name" {
  type        = string
  description = "Name of the ECS service"
  default     = ""
}
