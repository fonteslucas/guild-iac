resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_range
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "my_igw_on_terraform"
  }
}

resource "aws_subnet" "public_subnets" {
  count = 3
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = slice(cidrsubnets(var.cidr_range, 4, 4, 4), 0, 4)[count.index]
  availability_zone_id = data.aws_availability_zones.azs.zone_ids[count.index % length(data.aws_availability_zones.azs.zone_ids)]
}

resource "aws_subnet" "private_subnets" {
  count = 3
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = slice(cidrsubnets(var.cidr_range, 3, 3, 3, 3, 3, 3), 2, 6)[count.index]
  availability_zone_id = data.aws_availability_zones.azs.zone_ids[count.index % length(data.aws_availability_zones.azs.zone_ids)]
}