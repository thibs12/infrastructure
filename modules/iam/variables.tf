variable "ecs_task_name" {
  description = "The name of the ECS task"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}