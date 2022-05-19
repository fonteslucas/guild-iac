module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr_range

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = slice(var.cidr_notation, 0 , 3)
  public_subnets  = slice(var.cidr_notation, 3 , 6)

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}