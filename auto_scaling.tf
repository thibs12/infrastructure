module "auto_scaling" {
  source = "./modules/auto_scaling"
  role_arn = "TODO"
  resource_id = "TODO"
  cluster_name = module.ecs.main_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
  
}