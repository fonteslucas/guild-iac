module "vpc" {

  source   = "./aws_vpc"
  cidr_vpc = var.cidr-vpc

}
