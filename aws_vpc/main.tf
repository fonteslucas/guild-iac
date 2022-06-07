resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_vpc
}

resource "aws_subnet" "my_public_subnets" {
  for_each          = var.public_subnet_numbers
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_vpc, 4, each.value)
}

resource "aws_subnet" "my_private_subnets" {
  for_each          = var.private_subnet_numbers
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_vpc, 4, each.value)
}