module "security_groups" {
  source = "./modules/security_groups"
  sg_name = var.sg_name
  vpc_id = module.vpc.vpc_id
  app_port = var.app_port
}