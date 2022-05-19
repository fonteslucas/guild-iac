module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  name            = var.name-vpc
  cidr            = var.cidr-vpc
  azs             = data.aws_availability_zones.azs.names
  private_subnets = slice(cidrsubnets(var.cidr-vpc, 4, 4, 4), 0, 3)
  public_subnets  = slice(cidrsubnets(var.cidr-vpc, 4, 4, 4, 4, 4, 4), 3, 6)


  tags = {
    Terraform   = "true"
    Environment = "prod"
  }

}