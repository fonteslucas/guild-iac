  locals {
        private_subnets = slice(local.subnets, 0, 3)
        public_subnets  = slice(local.subnets, 3, 6)
        subnets = cidrsubnets(var.cidr-vpc, 4, 4, 4, 4, 4, 4)
  }
 