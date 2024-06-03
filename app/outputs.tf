output "alb_hostname" {
  value = "${module.alb.alb_hostname}:${var.app_port}"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_gateway_ids" {
  value = [module.subnet.nat_gateway_id_az1, module.subnet.nat_gateway_id_az2]
}