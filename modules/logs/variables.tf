variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the CloudWatch Log Group"
  type        = map(string)
  default     = {}
}