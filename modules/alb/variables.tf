variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default = ""
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
  default = ""
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
  default = ""
}

variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default = ""
}

variable "app_port" {
  description = "App port"
  type        = number
  default = 0
}