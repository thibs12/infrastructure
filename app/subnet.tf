module "subnet" {
  source              = "../modules/subnet"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  subnet_name         = var.subnet_name
  availability_zones   = data.aws_availability_zones.azs.names
  private_subnet_cidr = var.private_subnet_cidr

  nat_gtw_name = var.nat_gtw_name
}
