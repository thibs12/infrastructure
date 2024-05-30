variable "app_port" {
    type = number
    description = "Port exposed by docker image to redirect traffic to"
    default = 0
}

variable "vpc_id" {
    type = string
    description = "The VPC ID"
    default = ""
}

variable "sg_name" {
    type = string
    description = "The name of the security group"
    default = ""
}