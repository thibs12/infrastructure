variable "role_arn" {
  description = "The ARN of the IAM role that allows Application Auto Scaling to modify your scalable target."
  type = string
  default = ""
}

variable "resource_id" {
  description = "The identifier of the resource associated with the scalable target. This string consists of the resource type and unique identifier."
  type = string
  default = ""
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type = string
  default = ""
}

variable "ecs_service_name" {
  description = "The name of the ECS task"
  type = string
  default = ""
}