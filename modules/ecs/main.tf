resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.cluster_name}-cluster"
}

data "template_file" "template_app" {
  template = file("./templates/ecs/app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    app_cpu        = var.app_cpu
    app_memory     = var.app_memory
    db_cpu         = var.db_cpu
    db_memory      = var.db_memory
    aws_region     = var.aws_region
  }
}

data "template_file" "template_db" {
  template = file("./templates/ecs/mysql.json.tpl")

  vars = {
    db_cpu        = var.db_cpu
    db_memory     = var.db_memory
    aws_region    = var.aws_region
  }
}

resource "aws_service_discovery_private_dns_namespace" "db" {
  name        = "database.com"
  vpc         = var.vpc_id
  description = "Private DNS namespace for ECS services"
}

resource "aws_service_discovery_service" "mysql" {
  name          = "mysql"
  namespace_id  = aws_service_discovery_private_dns_namespace.db.id
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.db.id
    dns_records {
      type = "A"
      ttl  = 10
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}



resource "aws_ecs_task_definition" "db" {
  family                   = "${var.cluster_name}-db-task-definition"
  container_definitions    = data.template_file.template_db.rendered
  cpu                      = var.db_cpu
  memory                   = var.db_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
}

resource "aws_ecs_service" "db_service" {
  name            = "mysql-service"
  cluster         = aws_ecs_cluster.main_cluster.arn
  task_definition = aws_ecs_task_definition.db.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.mysql.arn
  }
  
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.cluster_name}-task-definition"
  container_definitions    = data.template_file.template_app.rendered
  cpu                      = var.app_cpu
  memory                   = var.app_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn = var.task_role_arn
}

resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  enable_execute_command = true
  cluster         = aws_ecs_cluster.main_cluster.arn
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.app_port
  }
}
