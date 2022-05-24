variable "cidr_vpc" {
  type    = string
  default = "10.0.0.0/20"
}

variable "public_subnet_numbers" {
  type = map(string)
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
  }
}

variable "private_subnet_numbers" {
  type = map(string)
  default = {
    "us-east-1a" = 4
    "us-east-1b" = 5
    "us-east-1c" = 6
  }
}

