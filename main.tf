module "vpc" {
  source = "./modules"

  cidr_range = var.cidr_range
  vpc_name = var.vpc_name
  
}