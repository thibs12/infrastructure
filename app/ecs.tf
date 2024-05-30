module "ecs" {
  source             = "../modules/ecs"
  cluster_name       = var.cluster_name
  app_image          = var.app_image
  app_port           = var.app_port
  fargate_cpu        = var.fargate_cpu
  fargate_memory     = var.fargate_memory
  app_cpu            = var.app_cpu
  app_memory         = var.app_memory
  db_cpu             = var.db_cpu
  db_memory          = var.db_memory
  aws_region         = var.region
  app_count          = var.app_count
  private_subnet_ids = [module.subnet.private_subnet_id_az1, module.subnet.private_subnet_id_az2]
  ecs_sg_id          = module.security_groups.ecs_sg_id
  target_group_arn   = module.alb.target_group_arn
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = var.task_role_arn
  vpc_id             = module.vpc.vpc_id
}
