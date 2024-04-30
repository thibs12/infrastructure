module "auto_scaling" {
  source = "./modules/auto_scaling"
  resource_id = "service/${module.ecs.main_cluster_name}/${module.ecs.ecs_service_name}"
  cluster_name = module.ecs.main_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
  
}