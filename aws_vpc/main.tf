resource "aws_vpc" "myVpc" {
  cidr_block = var.cidr_vpc
}

resource "aws_subnet" "mySubnetsPublic" {
  for_each          = var.public_subnet_numbers
  vpc_id            = aws_vpc.myVpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_vpc, 4, each.value)
}

resource "aws_subnet" "mySubnetsPrivate" {
  for_each          = var.private_subnet_numbers
  vpc_id            = aws_vpc.myVpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_vpc, 4, each.value)
}