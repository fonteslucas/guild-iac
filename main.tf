module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  name            = var.name-vpc
  cidr            = var.cidr-vpc
  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  igw_tags = {
    Name = "teste"
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }

}
