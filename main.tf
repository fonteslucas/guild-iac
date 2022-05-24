module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr_range

  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.private
  public_subnets  = local.public
}