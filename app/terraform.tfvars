region              = "eu-west-1"
vpc_cidr            = "172.16.0.0/16"
vpc_name            = "TL-VPC01"
public_subnet_cidr  = ["172.16.1.0/26", "172.16.16.0/26"]
private_subnet_cidr = ["172.16.3.0/26", "172.16.18.0/26"]
subnet_name         = "TL-Subnet"
nat_gtw_name        = "TL-NAT-GTW"
route_table_name    = "TL-Route-Table"
sg_name             = "TL-SG"
app_port            = 8080
alb_name            = "TL-ALB"
health_check_path   = "/"
app_image           = "thibs12/todolist:latest"
fargate_cpu         = 1024 # 1 vCPU
fargate_memory      = 2048 # 2GB
app_cpu             = 512
app_memory          = 1024
db_cpu              = 512
db_memory           = 1024
app_count           = 2
cluster_name        = "TL-ECS"
ecs_task_name       = "limited-TL-ECS-Task"
log_group_name      = "/ecs/app"
task_role_arn = "arn:aws:iam::891377364444:role/limited-task-role"


