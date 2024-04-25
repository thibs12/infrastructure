module "route_table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  route_table_name    = var.route_table_name
  internet_gateway_id = module.vpc.igw_id
  nat_gateway_id      = module.subnet.nat_gateway_id_az1
  public_subnet_id    = module.subnet.public_subnet_id_az1
  private_subnet_id   = module.subnet.private_subnet_id_az1

}
