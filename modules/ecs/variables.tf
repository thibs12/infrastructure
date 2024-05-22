variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = ""
}

variable "app_image" {
  description = "The Docker image to use for the ECS task"
  type        = string
  default     = ""
}

variable "app_port" {
  description = "The port the Docker container listens on"
  type        = number
  default     = 0
}

variable "fargate_cpu" {
  description = "The amount of CPU to allocate to the Fargate task"
  type        = number
  default     = 0
}

variable "fargate_memory" {
  description = "The amount of memory to allocate to the Fargate task"
  type        = number
  default     = 0
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

variable "aws_region" {
  description = "The AWS region to deploy the ECS cluster to"
  type        = string
  default     = ""
}

variable "app_count" {
  description = "The number of ECS tasks to run"
  type        = number
  default     = 0
}

variable "private_subnet_id" {
  description = "The ID of the private subnet to deploy the ECS service to"
  type        = string
  default     = ""
}

variable "ecs_sg_id" {
  description = "The ID of the security group to attach to the ECS service"
  type        = string
  default     = ""
}

variable "target_group_arn" {
  description = "The ARN of the target group to attach to the ECS service"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role to use for the ECS task execution"
  type        = string
  default     = ""
}
