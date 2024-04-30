module "alb" {
  source = "./modules/alb"
  alb_name = var.alb_name
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.subnet.public_subnet_id_az1
  alb_sg_id = module.security_groups.alb_sg_id
  health_check_path = var.health_check_path
  app_port = var.app_port
}