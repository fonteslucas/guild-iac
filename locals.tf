locals {
  private = slice(cidrsubnets(var.cidr_range,4,4,4), 0 , 3)
  public  = slice(cidrsubnets(var.cidr_range,4,4,4,4,4,4), 3 , 6)
}