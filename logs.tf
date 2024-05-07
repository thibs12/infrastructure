module "logs" {
    source = "./modules/logs"
    log_group_name = var.log_group_name
}