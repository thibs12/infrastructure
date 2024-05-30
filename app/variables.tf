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
  description = "The CIDR block for the subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnets"
  type        = list(string)
  default     = []
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

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = ""
}

variable "app_port" {
  description = "Port exposed by docker image to redirect traffic to"
  type        = number
  default     = 0
}

variable "health_check_path" {
  description = "The path to the health check endpoint"
  type        = string
  default     = ""
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = ""
}

variable "app_image" {
  description = "The docker image to deploy"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = ""
}

variable "fargate_cpu" {
  description = "The amount of CPU to allocate to the container"
  type        = number
  default     = 0
}

variable "fargate_memory" {
  description = "The amount of memory to allocate to the container"
  type        = number
  default     = 0
}

variable "app_count" {
  description = "The number of tasks to run"
  type        = number
  default     = 0
}

variable "ecs_task_name" {
  description = "The name of the ECS task"
  type        = string
  default     = ""
}

variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
  default     = ""
}

variable "app_cpu" {
  description = "The amount of CPU to allocate to the container"
  type        = number
  default     = 0
}

variable "app_memory" {
  description = "The amount of memory to allocate to the container"
  type        = number
  default     = 0
}

variable "db_cpu" {
  description = "The amount of CPU to allocate to the db container"
  type        = number
  default     = 0  
}

variable "db_memory" {
  description = "The amount of memory to allocate to the db container"
  type        = number
  default     = 0
}

variable "task_role_arn" {
  description = "The ARN of the task role"
  type        = string
  default     = ""
}