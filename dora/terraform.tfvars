sg_name             = "TL-SG"
db_username         = "dorauser"
db_password         = "dorapassword"
subnet_name         = "DB-subnet"
private_subnet_cidr = ["172.16.32.0/26", "172.16.34.0/26"]
route_table_name    = "DB-route-table"
db_endpoint         = "dora-db.ch6qay4mc0rv.eu-west-1.rds.amazonaws.com"
db_name             = "dora"
clusterArn          = "arn:aws:ecs:eu-west-1:891377364444:cluster/TL-ECS-cluster"
log_group_name      = "/ecs/app"
log_group_arn       = "arn:aws:logs:eu-west-1:891377364444:log-group:/ecs/app:*"
service_name        = "app-service"

