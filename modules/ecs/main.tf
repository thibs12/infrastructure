resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.cluster_name}-cluster"
}

data "template_file" "template_app" {
  template = file("./templates/ecs/app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.cluster_name}-task-definition"
  container_definitions    = data.template_file.template_app.rendered
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.main_cluster.arn
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.app_port
  }
}
