module "iam" {
  source = "../modules/iam"
  ecs_task_name = var.ecs_task_name
  tags = var.tags
}